USE Torverbarber;

-- Drop existing triggers before creating new ones
DROP TRIGGER IF EXISTS before_update_zona;
DROP TRIGGER IF EXISTS before_insert_zona;
DROP TRIGGER IF EXISTS before_insert_feedback;
-- DROP TRIGGER IF EXISTS after_insert_indirizzo_consegna;
-- DROP TRIGGER IF EXISTS after_update_indirizzo_consegna;
DROP TRIGGER IF EXISTS before_insert_prenotazione;

DELIMITER //

-- 1. Ensure that the assigned employee for a Zona is a "Responsabile di Zona"
CREATE TRIGGER before_insert_zona
BEFORE INSERT ON Zona
FOR EACH ROW
BEGIN
    DECLARE ruolo_dipendente VARCHAR(50);

    IF NEW.ResponsabileId IS NOT NULL THEN
        SELECT Ruolo.TipoRuolo 
        INTO ruolo_dipendente
        FROM Ruolo
        JOIN Dipendente ON Ruolo.RuoloId = Dipendente.RuoloId
        WHERE Dipendente.DipendenteId = NEW.ResponsabileId;

        IF ruolo_dipendente <> 'Responsabile di Zona' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Errore: Il dipendente assegnato deve essere un Responsabile di Zona';
        END IF;
    END IF;
END
//

CREATE TRIGGER before_update_zona
BEFORE UPDATE ON Zona
FOR EACH ROW
BEGIN
    DECLARE ruolo_dipendente VARCHAR(50);

    IF NEW.ResponsabileId IS NOT NULL THEN
        SELECT Ruolo.TipoRuolo 
        INTO ruolo_dipendente
        FROM Ruolo
        JOIN Dipendente ON Ruolo.RuoloId = Dipendente.RuoloId
        WHERE Dipendente.DipendenteId = NEW.ResponsabileId;

        IF ruolo_dipendente <> 'Responsabile di Zona' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Errore: Il dipendente assegnato deve essere un Responsabile di Zona';
        END IF;
    END IF;
END
//

-- 2. Ensure that feedback can only be given for completed appointments
CREATE TRIGGER before_insert_feedback
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    DECLARE stato_prenotazione VARCHAR(50);

    IF NEW.PrenotazioneId IS NOT NULL THEN
        SELECT stato
        INTO stato_prenotazione
        FROM Prenotazione
        WHERE PrenotazioneId = NEW.PrenotazioneId;

        IF stato_prenotazione <> 'Completato' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Errore: Il feedback deve essere relativo ad una prenotazione completata';
        END IF;
    END IF;
END
//

-- -- 3. Ensure only one default address per client
-- CREATE TRIGGER after_insert_indirizzo_consegna
-- AFTER INSERT ON IndirizzoConsegna
-- FOR EACH ROW
-- BEGIN
--     IF NEW.predefinito = 1 THEN
--         -- Resetta gli altri indirizzi predefiniti per lo stesso cliente
--         UPDATE IndirizzoConsegna
--         SET predefinito = 0
--         WHERE ClienteId = NEW.ClienteId
--         AND IndirizzoId <> NEW.IndirizzoId;
--     END IF;
-- END
-- //

-- CREATE TRIGGER after_update_indirizzo_consegna
-- AFTER UPDATE ON IndirizzoConsegna
-- FOR EACH ROW
-- BEGIN
--     IF NEW.predefinito = 1 THEN
--         -- Resetta gli altri indirizzi predefiniti per lo stesso cliente
--         UPDATE IndirizzoConsegna
--         SET predefinito = 0
--         WHERE ClienteId = NEW.ClienteId
--         AND IndirizzoId <> NEW.IndirizzoId;
--     END IF;
-- END
-- //

-- 4. Ensure that the assigned employee for a Prenotazione is a "Barbiere"
CREATE TRIGGER before_insert_prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE ruolo_dipendente VARCHAR(50);

    SELECT Ruolo.TipoRuolo
    INTO ruolo_dipendente
    FROM Ruolo
    JOIN Dipendente ON Dipendente.RuoloId = Ruolo.RuoloId
    WHERE Dipendente.DipendenteId = NEW.DipendenteId;

    IF ruolo_dipendente <> 'Barbiere' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: Il dipendente assegnato deve essere un Barbiere';
    END IF;
END
//

DELIMITER ;
