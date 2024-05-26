-- ÉVENEMENT PASSÉ DANS ARCHIVES 
CREATE OR REPLACE FUNCTION check_event_end_date() 
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

CREATE TRIGGER check_event_end_date_trigger
BEFORE INSERT ON Archives
FOR EACH ROW
EXECUTE FUNCTION check_event_end_date();


-- CAPACITÉ DU LIEU >= CAPACITÉ DE L'ÉVENEMENT
CREATE OR REPLACE FUNCTION check_event_capacity()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT capacite FROM Lieux WHERE l_id = NEW.lieu) < NEW.capacite THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_event_capacity
BEFORE INSERT OR UPDATE ON Evenements
FOR EACH ROW EXECUTE FUNCTION check_event_capacity();


-- ÉVENEMENT FUTUR DANS PROGRAMME
CREATE OR REPLACE FUNCTION check_event_start_date()
RETURNS TRIGGER AS $$
DECLARE
    debut_ev DATE;
BEGIN
    -- Récupération de la date de l'événement
    SELECT debut INTO debut_ev
    FROM Evenements
    WHERE e_id = NEW.e_id;

    -- Vérification que la date est future
    IF debut_ev < CURRENT_DATE THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_event_start_date
BEFORE INSERT ON Programmes
FOR EACH ROW EXECUTE FUNCTION check_event_start_date();