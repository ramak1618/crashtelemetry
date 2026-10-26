-- This SQL Script is completely AI-generated.
-- This is just for an example state of the server, to showcase query commands.

-- 12 servers
INSERT INTO Server (server_id, arch, cores) VALUES
(1,  'x86_64',  16),
(2,  'x86_64',  32),
(3,  'x86_64',  8),
(4,  'aarch64', 64),
(5,  'aarch64', 16),
(6,  'x86_64',  4),
(7,  'x86_64',  48),
(8,  'aarch64', 8),
(9,  'x86_64',  24),
(10, 'riscv64', 4),
(11, 'x86_64',  12),
(12, 'aarch64', 32);

-- 11 programs (6 service daemons, 5 user-initiated applications)
INSERT INTO Program (program_id, program_name, program_type) VALUES
(101, 'nginx',             'service'),
(102, 'sshd',              'service'),
(103, 'postgres',          'service'),
(104, 'node_exporter',     'service'),
(105, 'redis-server',      'service'),
(106, 'rsyslogd',          'service'),
(107, 'imgconvert',        'user'),
(108, 'report-gen',        'user'),
(109, 'backup-cli',        'user'),
(110, 'csv-importer',      'user'),
(111, 'video-transcoder',  'user');

-- 14 server/program installations (version is NULL where the creator did not provide one)
INSERT INTO ServerProgram (server_id, program_id, update_timestamp, version) VALUES
(1,  101, '2026-08-25 04:00:00', '1.24.0'),
(2,  101, '2026-09-01 04:10:00', '1.24.0'),
(3,  101, '2026-08-20 02:00:00', '1.24.0'),
(4,  102, '2026-07-25 01:30:00', '9.6p1'),
(5,  103, '2026-09-18 03:00:00', '16.4'),
(6,  104, '2026-06-15 05:45:00', '1.8.1'),
(7,  105, '2026-09-05 00:20:00', '7.2.4'),
(8,  105, '2026-09-12 00:25:00', '7.2.4'),
(9,  106, '2026-06-02 02:10:00', '8.2310.0'),
(10, 107, '2026-09-30 12:00:00', '3.1.0'),
(11, 108, '2026-09-20 09:30:00', NULL),
(1,  109, '2026-07-10 02:00:00', '2.4.1'),
(12, 110, '2026-10-01 08:15:00', NULL),
(2,  111, '2026-10-05 14:00:00', '5.1.3');

-- 12 fingerprints (SHA-256 of the stack trace text).
-- DEFAULT = initial state UNRESOLVED. RESOLVED / REGRESSION rows show states
-- reached later through developer updates and the regression rule.
INSERT INTO CrashFingerprint (hash, resolution_state) VALUES
('4cf9ed5d3888a198ef8f45046fa434ec7d9ef2c6d024351df5476e3670adf281', DEFAULT),      -- nginx SIGSEGV
('bff2bc7400bde7edd0f8188c1c2b8798ea95265a1e7b0c36979c00c3184adbaa', 'REGRESSION'), -- nginx abort, came back after fix
('03414351bd9d27d6cc535d13c6b996a75dc251a70ae9134465043cde572b54d2', 'RESOLVED'),   -- sshd
('33cf84a8ecbcd5552e19380ebefc009a7650b8668b161c87c136cb481a8b8b3c', DEFAULT),      -- postgres
('29d9ea174a242780e2c213ebe0854505c7549e213074026f30dc2295dc9f810e', 'RESOLVED'),   -- node_exporter
('9c6f0a1048c38afa4e93b282521500982b7bdb5a11cd21fcc9bfd46dae38494a', DEFAULT),      -- imgconvert
('37bcf448125ccfaf5a864ab55a2c4c95296a910b721430aba455da4bffcb476b', 'REGRESSION'), -- redis-server, came back after fix
('42465ca7d0f62cb6a579328b5e398c5d66054c5581e877a711f068284e5e671d', DEFAULT),      -- report-gen
('905704cef6c76f6b720b7f6ce8cfcac70b03956cbe72f5d33fceab31a0a22833', 'RESOLVED'),   -- backup-cli
('69e938497f91731cda4a6d109bcc59e735c40ef538eba55891cb3bb3d6138cea', DEFAULT),      -- csv-importer
('8dfd6743e8638ead9325cd92ce2592dec57197541d2c9b6d7080a1271d281b7b', DEFAULT),      -- video-transcoder
('3fa182aab455c06dc3e87685a974cbd7cd2f7024ea9c9c030e0a239b46c86095', 'RESOLVED');   -- rsyslogd

INSERT INTO Crash (server_id, program_id, crash_timestamp, process_uptime_ms, stack_trace, caught_signal, hash) VALUES
(1,  101, '2026-09-14 03:12:45', 5184000000,  'nginx+0x4a1f2\nnginx+0x3b9c0\nlibc.so.6+0x29d90',                          'SIGSEGV', '4cf9ed5d3888a198ef8f45046fa434ec7d9ef2c6d024351df5476e3670adf281'),
(2,  101, '2026-09-21 11:47:09', 604800123,   'nginx+0x4a1f2\nnginx+0x3b9c0\nlibc.so.6+0x29d90',                          'SIGSEGV', '4cf9ed5d3888a198ef8f45046fa434ec7d9ef2c6d024351df5476e3670adf281'),
(3,  101, '2026-08-02 06:30:15', 1209600000,  'libc.so.6+0x8e9fc\nlibc.so.6+0x42476\nnginx+0x5d3a8',                      'SIGABRT', 'bff2bc7400bde7edd0f8188c1c2b8798ea95265a1e7b0c36979c00c3184adbaa'),
(3,  101, '2026-10-12 19:05:52', 3456000000,  'libc.so.6+0x8e9fc\nlibc.so.6+0x42476\nnginx+0x5d3a8',                      'SIGABRT', 'bff2bc7400bde7edd0f8188c1c2b8798ea95265a1e7b0c36979c00c3184adbaa'),
(4,  102, '2026-07-19 22:41:30', 432000000,   'sshd+0x2c4e1\nsshd+0x1f7a3\nlibc.so.6+0x29d90',                            'SIGSEGV', '03414351bd9d27d6cc535d13c6b996a75dc251a70ae9134465043cde572b54d2'),
(5,  103, '2026-10-03 01:15:00', 7776000000,  'postgres+0x6b21f0\npostgres+0x5a88d4\npostgres+0x3f12a6',                  'SIGBUS',  '33cf84a8ecbcd5552e19380ebefc009a7650b8668b161c87c136cb481a8b8b3c'),
(6,  104, '2026-06-11 14:20:33', 259200000,   'node_exporter+0x1d4b90\nnode_exporter+0x1a2210\nlibc.so.6+0x27c4a',        'SIGSEGV', '29d9ea174a242780e2c213ebe0854505c7549e213074026f30dc2295dc9f810e'),
(7,  105, '2026-08-30 08:09:41', 1814400000,  'redis-server+0x1b7c42\nredis-server+0x9f3d1\nlibc.so.6+0x29d90',          'SIGSEGV', '37bcf448125ccfaf5a864ab55a2c4c95296a910b721430aba455da4bffcb476b'),
(8,  105, '2026-10-19 16:55:18', 950400000,   'redis-server+0x1b7c42\nredis-server+0x9f3d1\nlibc.so.6+0x29d90',          'SIGSEGV', '37bcf448125ccfaf5a864ab55a2c4c95296a910b721430aba455da4bffcb476b'),
(9,  106, '2026-05-27 23:59:59', 12096000000, 'rsyslogd+0x3a9e4\nlibc.so.6+0xf5d12\nrsyslogd+0x21c0',                    'SIGXFSZ', '3fa182aab455c06dc3e87685a974cbd7cd2f7024ea9c9c030e0a239b46c86095'),
(10, 107, '2026-10-08 10:33:27', 4120,        'libimgproc.so+0x9e34\nimgconvert+0x2a10\nlibc.so.6+0x29d90',             'SIGSEGV', '9c6f0a1048c38afa4e93b282521500982b7bdb5a11cd21fcc9bfd46dae38494a'),
(11, 108, '2026-09-29 17:02:11', 18500,       'libc.so.6+0x8e9fc\nlibstdc++.so.6+0xa5b2e\nreport-gen+0x7c41',            'SIGABRT', '42465ca7d0f62cb6a579328b5e398c5d66054c5581e877a711f068284e5e671d'),
(1,  109, '2026-07-04 02:00:07', 900,         'libc.so.6+0x11a8d2\nbackup-cli+0x3e07\nbackup-cli+0x2b91',                'SIGSYS',  '905704cef6c76f6b720b7f6ce8cfcac70b03956cbe72f5d33fceab31a0a22833'),
(12, 110, '2026-10-22 13:44:50', 61230,       'csv-importer+0x5f12\nlibc.so.6+0x1a3b40\ncsv-importer+0x4430',            'SIGFPE',  '69e938497f91731cda4a6d109bcc59e735c40ef538eba55891cb3bb3d6138cea'),
(2,  111, '2026-10-17 21:18:36', 7342100,     'libavcodec.so.60+0x4e2c10\nlibavcodec.so.60+0x4d8a77\nvideo-transcoder+0x1c58', 'SIGILL', '8dfd6743e8638ead9325cd92ce2592dec57197541d2c9b6d7080a1271d281b7b');
