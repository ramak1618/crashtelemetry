DELIMITER //

-- submit a crash payload. abstracts SHA2 function.
-- signal can be taken as VARCHAR. It will convert it to appropriate ENUM.
-- [WARNING]: assumes triggers.sql already ran; so that CrashFingerprint auto-updates.
CREATE PROCEDURE crash_payload(IN servid INT, IN progid INT, IN ts TIMESTAMP, IN up BIGINT, IN trace BLOB, IN sgnl VARCHAR(10))
BEGIN
    INSERT INTO Crash VALUES (servid, progid, ts, up, trace, sgnl, SHA2(trace, 256));
END //


-- Get crashes per fingerprint
CREATE PROCEDURE num_crashes(IN hashval CHAR(64))
BEGIN
    SELECT COUNT(*) FROM Crash WHERE hash = hashval;
END //

DELIMITER ;
