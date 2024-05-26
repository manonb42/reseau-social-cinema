-- Création de la fonction de trigger
CREATE OR REPLACE FUNCTION check_event_date() 
RETURNS TRIGGER AS $$
DECLARE
    event_fin DATE;
BEGIN
    -- Récupération de la date de fin de l'événement depuis la table Evenements
    SELECT fin INTO event_fin 
    FROM Evenements 
    WHERE e_id = NEW.e_id;

    -- Vérification que la date de fin est passée
    IF event_fin > CURRENT_DATE THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Création du trigger sur la table Archives
CREATE TRIGGER check_event_date_trigger
BEFORE INSERT ON Archives
FOR EACH ROW
EXECUTE FUNCTION check_event_date();