CREATE TABLE Server(
    server_id INT NOT NULL, 
    arch VARCHAR(32) NOT NULL, 
    cores INT NOT NULL, 
    PRIMARY KEY (server_id)
);

CREATE TABLE Program(
    program_id INT NOT NULL,
    program_name VARCHAR(256) NOT NULL,
    program_type ENUM('service', 'user') NOT NULL,
    PRIMARY KEY (program_id)
);

CREATE TABLE ServerProgram(
    server_id INT NOT NULL,
    program_id INT NOT NULL,
    update_timestamp TIMESTAMP NOT NULL,
    version VARCHAR(32), -- Nullable, in case not provided by creator.
    FOREIGN KEY (server_id) REFERENCES Server(server_id),
    FOREIGN KEY (program_id) REFERENCES Program(program_id),
    PRIMARY KEY (server_id, program_id)
);

CREATE TABLE CrashFingerprint(
    hash CHAR(64) NOT NULL,
    resolution_state ENUM('UNRESOLVED', 'RESOLVED', 'REGRESSION') NOT NULL DEFAULT 'UNRESOLVED',
    PRIMARY KEY (hash)
);

CREATE TABLE Crash(
    server_id INT NOT NULL,
    program_id INT NOT NULL,
    crash_timestamp TIMESTAMP NOT NULL,
    process_uptime_ms BIGINT NOT NULL,
    stack_trace BLOB NOT NULL, 
    caught_signal ENUM('SIGABRT', 'SIGBUS', 'SIGFPE', 'SIGILL', 'SIGQUIT', 'SIGSEGV', 'SIGSYS', 'SIGTRAP', 'SIGXCPU', 'SIGXFSZ') NOT NULL,
    hash CHAR(64) NOT NULL,

    FOREIGN KEY (server_id, program_id) REFERENCES ServerProgram(server_id, program_id),
    FOREIGN KEY (hash) REFERENCES CrashFingerprint(hash),
    PRIMARY KEY (server_id, program_id, crash_timestamp)
);
