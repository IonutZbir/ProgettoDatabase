USE Torverbarber;

DELIMITER //

CREATE PROCEDURE HashPassword(
    IN raw_password VARCHAR(255),
    OUT hashed_password VARCHAR(255)
)
BEGIN
    -- Hash the password using SHA2-256
    SET hashed_password = SHA2(raw_password, 256);
END;
//

DELIMITER ;
