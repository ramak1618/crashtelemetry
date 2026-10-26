-- Trigger for CrashFingerprint auto-update
DELIMITER //
CREATE TRIGGER fingerprint_resolve BEFORE INSERT ON Crash -- has to be BEFORE as FOREIGN KEY CONSTRAINT has to satisfy
FOR EACH ROW
BEGIN
    -- this is like an optional<hash>
    DECLARE hash_value CHAR(64);

    -- init optional to NULL if not exist, otherwise give it the value
    SELECT NEW.hash INTO hash_value 
    FROM CrashFingerprint 
    WHERE hash = NEW.hash;

    IF hash_value IS NULL THEN 
        INSERT INTO CrashFingerprint (hash) VALUES (NEW.hash);
    ELSE
        UPDATE CrashFingerprint SET resolution_state='REGRESSION' 
        WHERE hash = hash_value AND resolution_state = 'RESOLVED';
    END IF;
END //

DELIMITER ;
