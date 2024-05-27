-- ÉVENEMENT PASSÉ DANS ARCHIVES 
CREATE OR REPLACE FUNCTION evenement_passe_archive() 
RETURNS TRIGGER AS $$
DECLARE
    event_fin DATE;
BEGIN
    SELECT fin INTO event_fin 
    FROM Evenements 
    WHERE e_id = NEW.e_id;

    IF event_fin > CURRENT_DATE THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_evenement_passe_archive
BEFORE INSERT ON Archives
FOR EACH ROW
EXECUTE FUNCTION evenement_passe_archive();





-- ÉVENEMENT FUTUR DANS PROGRAMME
CREATE OR REPLACE FUNCTION evenement_futur_programme()
RETURNS TRIGGER AS $$
DECLARE
    debut_ev DATE;
BEGIN
    SELECT debut INTO debut_ev
    FROM Evenements
    WHERE e_id = NEW.e_id;

    IF debut_ev < CURRENT_DATE THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_evenement_futur_programme
BEFORE INSERT ON Programmes
FOR EACH ROW EXECUTE FUNCTION evenement_futur_programme();





-- CAPACITÉ DU LIEU >= CAPACITÉ DE L'ÉVENEMENT
CREATE OR REPLACE FUNCTION capacite_lieu_evenement()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT capacite FROM Lieux WHERE l_id = NEW.lieu) < NEW.capacite THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_capacite_lieu_evenement
BEFORE INSERT OR UPDATE ON Evenements
FOR EACH ROW EXECUTE FUNCTION capacite_lieu_evenement();






-- DANS PARTICIPANTS : LE NOMBRE D'INSCRITS EST <= A LA CAPACITÉ DE EVENEMENTS

CREATE OR REPLACE FUNCTION capacite_evements_participants()
RETURNS TRIGGER AS $$
DECLARE
    capacite_event INT;
    nb_inscrits INT;
BEGIN
    -- Récupérer la capacité de l'événement
    SELECT capacite INTO capacite_event
    FROM Evenements
    WHERE e_id = NEW.e_id;
    
    -- Compter le nombre d'inscrits pour cet événement
    SELECT COUNT(*) INTO nb_inscrits
    FROM Participants
    WHERE e_id = NEW.e_id AND inscrit = TRUE;
    
    -- Ajouter 1 à nb_inscrits si l'opération actuelle est une inscription
    IF NEW.inscrit = TRUE THEN
        nb_inscrits := nb_inscrits + 1;
    END IF;
    
    -- Vérifier que le nombre d'inscrits ne dépasse pas la capacité
    IF nb_inscrits > capacite_event THEN
        RETURN NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_capacite_evements_participants
BEFORE INSERT OR UPDATE ON Participants
FOR EACH ROW
EXECUTE FUNCTION capacite_evements_participants();



-- A LA CREATION D'UN COMPTEARTISTE ON VERIFIE QUE LES ATTRIBUTS DE UTILISATEUR ET ARTISTE SONT COHERENTS

CREATE OR REPLACE FUNCTION artiste_coherence_attributs()
RETURNS TRIGGER AS $$
DECLARE
    utilisateur_nom VARCHAR;
    utilisateur_prenom VARCHAR;
    utilisateur_birth DATE;
    utilisateur_pays VARCHAR;
    
    artiste_nom VARCHAR;
    artiste_prenom VARCHAR;
    artiste_birth DATE;
    artiste_pays VARCHAR;
BEGIN
    -- Récupérer les informations de l'utilisateur
    SELECT nom, prenom, birth, pays
    INTO utilisateur_nom, utilisateur_prenom, utilisateur_birth, utilisateur_pays
    FROM Utilisateurs
    WHERE u_id = NEW.u_id;

    -- Récupérer les informations de l'artiste
    SELECT nom, prenom, birth, pays
    INTO artiste_nom, artiste_prenom, artiste_birth, artiste_pays
    FROM Artistes
    WHERE a_id = NEW.a_id;

    -- Comparer chaque champ 
    IF utilisateur_nom IS DISTINCT FROM artiste_nom OR
       utilisateur_prenom IS DISTINCT FROM artiste_prenom OR
       utilisateur_birth IS DISTINCT FROM artiste_birth OR
       utilisateur_pays IS DISTINCT FROM artiste_pays THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_coherence_artistes
BEFORE INSERT ON ComptesArtistes
FOR EACH ROW
EXECUTE FUNCTION artiste_coherence_attributs();





-- DANS CONVERSATIONS : SOURCE ET REPONSE SONT DANS LA MÊME DISCUSSION 

CREATE OR REPLACE FUNCTION conversation_coherence_attributs()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        SELECT d_id
        FROM Publications
        WHERE p_id = NEW.source
    ) IS DISTINCT FROM (
        SELECT d_id
        FROM Publications
        WHERE p_id = NEW.reponse
    ) THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_coherence_conversation
BEFORE INSERT ON Conversations
FOR EACH ROW
EXECUTE FUNCTION conversation_coherence_attributs();





-- ON VERIFIE QUE DEUX EVENEMENTS AU MÊME LIEU NE SE SUPERPOSENT PAS 

CREATE OR REPLACE FUNCTION superposition_evenements()
RETURNS TRIGGER AS $$
BEGIN 
    IF EXISTS (
        SELECT *
        FROM Evenements
        WHERE lieu = NEW.lieu
          AND daterange(debut, fin, '[]') && daterange(NEW.debut, NEW.fin, '[]')
    ) THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_superposition
BEFORE INSERT OR UPDATE ON Evenements
FOR EACH ROW
EXECUTE FUNCTION superposition_evenements();




-- L'UTILISATEUR NE MET UN AVIS SUR UN EVENEMENT QUE SI IL EST INSCRIT A L'EVENEMENT ET QUE L'EVENEMENT EST PASSE 

CREATE OR REPLACE FUNCTION etat_avis_evenement()
RETURNS TRIGGER AS $$
BEGIN
    -- On vérifie si l'utilisateur a participé à l'événement
    IF NOT EXISTS (
        SELECT 1 
        FROM Participants 
        WHERE Participants.u_id = NEW.u_id
        AND Participants.e_id = NEW.e_id
    ) THEN
        RETURN NULL;
    END IF;

    -- On vérifie si l'événement est passé
    IF NOT EXISTS (
        SELECT 1
        FROM Evenements
        WHERE Evenements.e_id = NEW.e_id
        AND Evenements.fin < CURRENT_DATE
    ) THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_etat_avis
BEFORE INSERT OR UPDATE ON AvisEvenements
FOR EACH ROW
EXECUTE FUNCTION etat_avis_evenement();