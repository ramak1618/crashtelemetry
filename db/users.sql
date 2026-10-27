CREATE DATABASE IF NOT EXISTS crashtelemetry;

CREATE USER 'daemon'@'localhost' IDENTIFIED BY 'daem';
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adm';

GRANT ALL PRIVILEGES ON crashtelemetry.* TO 'admin'@'localhost'; 

-- dont let dev delete crash logs he does not want to fix
GRANT SELECT, INSERT, UPDATE ON crashtelemetry.* TO 'dev'@'localhost';
GRANT DELETE ON crashtelemetry.Server TO 'dev'@'localhost';
GRANT DELETE ON crashtelemetry.Program TO 'dev'@'localhost';
GRANT DELETE ON crashtelemetry.ServerProgram TO 'dev'@'localhost';

-- crash daemon only needs to insert crash and possibly do regress resolved fingerprints.
GRANT INSERT ON crashtelemetry.Crash TO 'daemon'@'localhost';
GRANT INSERT ON crashtelemetry.CrashFingerprint TO 'daemon'@'localhost';
GRANT UPDATE ON crashtelemetry.CrashFingerprint TO 'daemon'@'localhost';

FLUSH PRIVILEGES;
