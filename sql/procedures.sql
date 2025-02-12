USE Torverbarber;

DROP PROCEDURE IF EXISTS HashPassword;
DROP PROCEDURE IF EXISTS ResetPredefinito;

DELIMITER //

CREATE PROCEDURE HashPassword (
    IN raw_password VARCHAR(255),
    OUT hashed_password VARCHAR(255)
) 
BEGIN
    -- Hash the password using SHA2-256
    SET hashed_password = SHA2(raw_password, 256);
END
//

CREATE PROCEDURE ResetPredefinito (
    IN cliente_id INT, 
    IN indirizzo_id INT
) 
BEGIN
    UPDATE IndirizzoConsegna
    SET predefinito = 0
    WHERE ClienteId = cliente_id
    AND IndirizzoId <> indirizzo_id;
END
//

DELIMITER ;
