DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE cities
(
    city_id        CHAR(3) PRIMARY KEY,
    name           TEXT NOT NULL,
    province_state TEXT NOT NULL
);

CREATE TABLE buildings
(
    building_id SERIAL PRIMARY KEY,
    city_id     CHAR(3)       NOT NULL,
    code        INT           NOT NULL,
    address     TEXT          NOT NULL,
    lat         DECIMAL(9, 6) NOT NULL,
    lon         DECIMAL(9, 6) NOT NULL,
    is_active   BOOLEAN       NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities (city_id),
    UNIQUE (city_id, code)
);

CREATE TABLE rooms
(
    room_id     SERIAL PRIMARY KEY,
    building_id INT     NOT NULL,
    floor       INT     NOT NULL,
    code        TEXT    NOT NULL,
    name        TEXT    NOT NULL,
    seats       INT     NOT NULL,
    is_active   BOOLEAN NOT NULL,
    FOREIGN KEY (building_id) REFERENCES buildings (building_id),
    UNIQUE (building_id, floor, code)
);

CREATE TABLE equipments
(
    equipment_id CHAR(2) PRIMARY KEY,
    description  TEXT NOT NULL
);

CREATE TABLE rooms_equipments
(
    room_id      INT,
    equipment_id CHAR(2),
    PRIMARY KEY (room_id, equipment_id),
    FOREIGN KEY (room_id) REFERENCES rooms (room_id),
    FOREIGN KEY (equipment_id) REFERENCES equipments (equipment_id)
);

CREATE TYPE role AS ENUM ('admin', 'staff');

CREATE TABLE users
(
    user_id     SERIAL PRIMARY KEY,
    username    TEXT    NOT NULL UNIQUE,
    first_name  TEXT    NOT NULL,
    last_name   TEXT    NOT NULL,
    email       TEXT    NOT NULL UNIQUE,
    building_id INT     NOT NULL,
    floor       INT     NOT NULL,
    desk        INT     NOT NULL,
    role        role    NOT NULL,
    is_active   BOOLEAN NOT NULL,
    FOREIGN KEY (building_id) REFERENCES buildings (building_id)
);

CREATE TYPE status AS ENUM ('confirmed', 'canceled');

CREATE TABLE bookings
(
    booking_id SERIAL PRIMARY KEY,
    created_by INT       NOT NULL,
    created_at TIMESTAMP NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time   TIMESTAMP NOT NULL,
    status     status    NOT NULL,
    FOREIGN KEY (created_by) REFERENCES users (user_id)
);

CREATE TABLE events
(
    event_id   SERIAL PRIMARY KEY,
    title      TEXT      NOT NULL,
    created_by INT       NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time   TIMESTAMP NOT NULL,
    FOREIGN KEY (created_by) REFERENCES users (user_id)
);

CREATE TABLE users_bookings
(
    user_id    INT,
    booking_id INT,
    room_id    INT NOT NULL,
    PRIMARY KEY (user_id, booking_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id),
    FOREIGN KEY (room_id) REFERENCES rooms (room_id)
);

CREATE TABLE distances
(
    building_id_from INT,
    building_id_to   INT,
    distance         INT NOT NULL,
    PRIMARY KEY (building_id_from, building_id_to)
);

INSERT INTO cities (city_id, name, province_state)
VALUES ('YVR', 'Vancouver', 'BC'),
       ('YYZ', 'Toronto', 'ON'),
       ('YUL', 'Montreal', 'QC'),
       ('SEA', 'Seattle', 'WA'),
       ('PDX', 'Portland', 'OR');

INSERT INTO buildings (building_id, city_id, code, address, lat, lon, is_active)
VALUES (1, 'YVR', 32, '32 Vancouver St, Vancouver, BC A1B 2C3', 49.278140, -123.128805, TRUE),
       (2, 'YVR', 41, '41 West Vancouver St, West Vancouver, BC A1B 2C3', 49.330272, -123.160091, TRUE),
       (3, 'YVR', 74, '74 Burnaby St, Burnaby, BC A1B 2C3', 49.248486, -122.980708, TRUE),
       (4, 'YVR', 63, '63 Richmond St, Richmond, BC A1B 2C3', 49.150386, -123.136633, TRUE),
       (5, 'YVR', 73, '73 Coquitlam St, Coquitlam, BC A1B 2C3', 49.283103, -122.792834, TRUE),
       (6, 'YYZ', 34, '34 Toronto St, Toronto, ON D1E 2F3', 43.649982, -79.380446, TRUE),
       (7, 'YUL', 22, '22 Montreal St, Montreal, QC G1H 2I3', 45.502746, -73.560693, TRUE);

SELECT setval('buildings_building_id_seq', (SELECT MAX(building_id) FROM buildings));

INSERT INTO equipments (equipment_id, description)
VALUES ('AV', 'Audio visual equipment in room'),
       ('VC', 'Video Conference equipment in room');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (1, 1, 1, '101', 'Stanley', 4, TRUE),
       (2, 1, 1, '102', 'Trafalgar', 6, TRUE),
       (3, 1, 1, '404', 'Lighthouse', 18, TRUE),
       (4, 1, 1, '405', 'Earles Casual', 4, FALSE),
       (5, 1, 1, '406', 'Riley', 8, TRUE),
       (6, 1, 2, '101', 'Yaletown', 4, TRUE),
       (7, 1, 2, '102', 'Kerrisdale', 6, TRUE),
       (8, 1, 2, '103', 'Gastown', 16, TRUE),
       (9, 1, 2, '404', 'Killarney', 18, TRUE),
       (10, 1, 2, '405', 'Grandview Casual', 5, TRUE),
       (11, 1, 2, '406', 'Marpole', 10, TRUE),
       (12, 1, 3, '101', 'Chickadee', 4, TRUE),
       (13, 1, 3, '102', 'Reservoir', 6, TRUE),
       (14, 1, 3, '103', 'Thompson', 16, TRUE),
       (15, 1, 3, '404', 'Brockton', 18, TRUE),
       (16, 1, 3, '405', 'Kinglet Casual', 5, TRUE),
       (17, 1, 3, '406', 'Ravine', 10, TRUE),
       (18, 1, 4, '100', 'Interview', 4, TRUE),
       (19, 1, 4, '101', 'Interview', 4, TRUE),
       (20, 1, 4, '203', 'English Bay Combinable', 38, TRUE),
       (21, 1, 4, '204', 'Sunset Combinable', 38, TRUE),
       (22, 1, 4, '300', 'Jericho', 26, TRUE),
       (23, 1, 5, '101', 'Sockeye', 4, TRUE),
       (24, 1, 5, '102', 'Coho', 6, TRUE),
       (25, 1, 5, '103', 'Chinook', 16, TRUE),
       (26, 1, 5, '403', '', 14, TRUE),
       (27, 1, 5, '404', 'Char', 18, TRUE),
       (28, 1, 5, '405', 'Steelhead Casual', 5, TRUE),
       (29, 1, 5, '406', 'Kokanee', 10, TRUE),
       (30, 1, 6, '101', 'Okanagan', 4, TRUE),
       (31, 1, 6, '102', 'Buntzen', 6, TRUE),
       (32, 1, 6, '103', 'Elfin', 16, TRUE),
       (33, 1, 6, '403', 'Babine', 14, TRUE),
       (34, 1, 6, '404', 'Ootsa', 18, TRUE),
       (35, 1, 6, '405', 'Sprott Casual', 5, TRUE),
       (36, 1, 6, '406', 'Kootenay', 10, TRUE),
       (37, 1, 7, '100', 'Eagle', 10, TRUE),
       (38, 1, 7, '101', 'Lynx', 18, TRUE),
       (39, 1, 7, '404', 'Kermode', 4, TRUE),
       (40, 1, 7, '405', 'Orca', 4, TRUE),
       (41, 1, 7, '406', 'Moose Casual', 5, TRUE),
       (42, 1, 7, '407', 'Raccoon', 12, TRUE);

INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (1, 'AV'),
       (1, 'VC'),
       (3, 'AV'),
       (3, 'VC'),
       (4, 'VC'),
       (5, 'AV'),
       (5, 'VC'),
       (6, 'AV'),
       (6, 'VC'),
       (8, 'VC'),
       (9, 'AV'),
       (9, 'VC'),
       (12, 'AV'),
       (12, 'VC'),
       (13, 'AV'),
       (13, 'VC'),
       (14, 'AV'),
       (14, 'VC'),
       (15, 'AV'),
       (15, 'VC'),
       (17, 'AV'),
       (17, 'VC'),
       (20, 'AV'),
       (20, 'VC'),
       (21, 'AV'),
       (21, 'VC'),
       (22, 'AV'),
       (22, 'VC'),
       (23, 'AV'),
       (23, 'VC'),
       (25, 'AV'),
       (25, 'VC'),
       (26, 'AV'),
       (26, 'VC'),
       (27, 'AV'),
       (27, 'VC'),
       (30, 'AV'),
       (30, 'VC'),
       (32, 'AV'),
       (32, 'VC'),
       (33, 'AV'),
       (33, 'VC'),
       (34, 'AV'),
       (34, 'VC'),
       (38, 'AV'),
       (38, 'VC'),
       (40, 'AV'),
       (40, 'VC'),
       (42, 'AV'),
       (42, 'VC');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (43, 2, 1, '401', 'Interview Room', 4, TRUE),
       (44, 2, 2, '100', '', 4, TRUE),
       (45, 2, 2, '101', '', 4, TRUE),
       (46, 2, 2, '103', '', 12, TRUE),
       (47, 2, 2, '104', '', 4, TRUE),
       (48, 2, 2, '105', '', 18, TRUE),
       (49, 2, 2, '200', '', 4, TRUE),
       (50, 2, 2, '201', '', 4, TRUE),
       (51, 2, 2, '204', '', 14, TRUE),
       (52, 2, 2, '401', '', 12, TRUE),
       (53, 2, 3, '100', '', 8, TRUE),
       (54, 2, 3, '101', '', 4, TRUE),
       (55, 2, 3, '102', '', 12, TRUE),
       (56, 2, 3, '103', '', 4, TRUE),
       (57, 2, 3, '104', '', 18, TRUE),
       (58, 2, 3, '200', '', 10, TRUE),
       (59, 2, 3, '201', '', 14, TRUE),
       (60, 2, 3, '301', '', 4, TRUE),
       (61, 2, 3, '302', '', 4, TRUE),
       (62, 2, 3, '400', '', 12, TRUE),
       (63, 2, 4, '100', '', 8, TRUE),
       (64, 2, 4, '101', '', 4, TRUE),
       (65, 2, 4, '102', 'Conference Room', 12, TRUE),
       (66, 2, 4, '103', '', 4, TRUE),
       (67, 2, 4, '104', '', 18, TRUE),
       (68, 2, 4, '200', '', 6, TRUE),
       (69, 2, 4, '201', '', 6, TRUE),
       (70, 2, 4, '202', '', 14, TRUE),
       (71, 2, 4, '300', '', 4, TRUE),
       (72, 2, 4, '301', '', 4, TRUE),
       (73, 2, 4, '302', '', 4, TRUE),
       (74, 2, 5, '102', '', 5, TRUE),
       (75, 2, 5, '200', '', 14, TRUE),
       (76, 2, 5, '201', '', 8, TRUE),
       (77, 2, 5, '202', '', 4, TRUE),
       (78, 2, 5, '203', '', 4, TRUE),
       (79, 2, 5, '204', '', 4, TRUE),
       (80, 2, 5, '205', '', 4, TRUE),
       (81, 2, 5, '206', '', 18, TRUE),
       (82, 2, 5, '300', '', 6, TRUE),
       (83, 2, 5, '301', '', 4, TRUE),
       (84, 2, 6, '100', '', 4, TRUE),
       (85, 2, 6, '101', '', 4, TRUE),
       (86, 2, 6, '102', '', 12, TRUE),
       (87, 2, 6, '103', '', 4, TRUE),
       (88, 2, 6, '301', '', 6, TRUE),
       (89, 2, 7, '100', '', 12, TRUE),
       (90, 2, 7, '101', '', 8, TRUE),
       (91, 2, 7, '102', '', 4, TRUE),
       (92, 2, 7, '103', '', 18, TRUE),
       (93, 2, 7, '200', '', 4, TRUE),
       (94, 2, 7, '201', '', 14, TRUE),
       (95, 2, 7, '300', '', 8, TRUE),
       (96, 2, 7, '301', '', 4, TRUE),
       (97, 2, 7, '304', '', 4, TRUE),
       (98, 2, 7, '400', '', 8, TRUE),
       (99, 2, 8, '300', 'Boardroom', 22, TRUE),
       (100, 2, 8, '301', 'Boardroom Combinable', 30, TRUE),
       (101, 2, 8, '302', 'Boardroom Combinable', 30, TRUE),
       (102, 2, 9, '100', '', 10, TRUE),
       (103, 2, 9, '101', '', 4, TRUE),
       (104, 2, 9, '102', '', 4, TRUE),
       (105, 2, 9, '103', '', 8, TRUE),
       (106, 2, 9, '201', '', 4, TRUE),
       (107, 2, 9, '202', '', 4, TRUE),
       (108, 2, 9, '300', '', 4, TRUE);

INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (44, 'AV'),
       (44, 'VC'),
       (45, 'AV'),
       (45, 'VC'),
       (46, 'AV'),
       (46, 'VC'),
       (47, 'AV'),
       (47, 'VC'),
       (48, 'AV'),
       (48, 'VC'),
       (49, 'AV'),
       (49, 'VC'),
       (50, 'AV'),
       (50, 'VC'),
       (51, 'AV'),
       (51, 'VC'),
       (52, 'AV'),
       (52, 'VC'),
       (53, 'AV'),
       (53, 'VC'),
       (54, 'AV'),
       (54, 'VC'),
       (55, 'AV'),
       (55, 'VC'),
       (56, 'AV'),
       (56, 'VC'),
       (57, 'AV'),
       (57, 'VC'),
       (58, 'AV'),
       (58, 'VC'),
       (59, 'AV'),
       (59, 'VC'),
       (60, 'AV'),
       (60, 'VC'),
       (61, 'AV'),
       (61, 'VC'),
       (62, 'AV'),
       (62, 'VC'),
       (63, 'AV'),
       (63, 'VC'),
       (64, 'AV'),
       (64, 'VC'),
       (65, 'AV'),
       (65, 'VC'),
       (66, 'AV'),
       (66, 'VC'),
       (67, 'AV'),
       (67, 'VC'),
       (68, 'AV'),
       (68, 'VC'),
       (69, 'AV'),
       (69, 'VC'),
       (70, 'AV'),
       (70, 'VC'),
       (71, 'AV'),
       (71, 'VC'),
       (72, 'AV'),
       (72, 'VC'),
       (73, 'AV'),
       (73, 'VC'),
       (74, 'AV'),
       (74, 'VC'),
       (75, 'AV'),
       (75, 'VC'),
       (76, 'AV'),
       (76, 'VC'),
       (77, 'AV'),
       (77, 'VC'),
       (78, 'AV'),
       (78, 'VC'),
       (79, 'AV'),
       (79, 'VC'),
       (80, 'AV'),
       (80, 'VC'),
       (81, 'AV'),
       (81, 'VC'),
       (82, 'AV'),
       (82, 'VC'),
       (83, 'AV'),
       (83, 'VC'),
       (84, 'AV'),
       (84, 'VC'),
       (85, 'AV'),
       (85, 'VC'),
       (86, 'AV'),
       (86, 'VC'),
       (87, 'AV'),
       (87, 'VC'),
       (88, 'AV'),
       (88, 'VC'),
       (89, 'AV'),
       (89, 'VC'),
       (90, 'AV'),
       (90, 'VC'),
       (91, 'AV'),
       (91, 'VC'),
       (92, 'AV'),
       (92, 'VC'),
       (93, 'AV'),
       (93, 'VC'),
       (94, 'AV'),
       (94, 'VC'),
       (95, 'AV'),
       (95, 'VC'),
       (96, 'AV'),
       (96, 'VC'),
       (97, 'AV'),
       (97, 'VC'),
       (98, 'AV'),
       (98, 'VC'),
       (99, 'AV'),
       (99, 'VC'),
       (100, 'AV'),
       (100, 'VC'),
       (101, 'AV'),
       (101, 'VC'),
       (102, 'AV'),
       (102, 'VC'),
       (103, 'AV'),
       (103, 'VC'),
       (104, 'AV'),
       (104, 'VC'),
       (105, 'AV'),
       (105, 'VC'),
       (106, 'AV'),
       (106, 'VC'),
       (107, 'AV'),
       (107, 'VC'),
       (108, 'AV'),
       (108, 'VC');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (109, 3, 1, '100', 'Hollyburn', 8, TRUE),
       (110, 3, 1, '101', 'Strachan', 8, TRUE),
       (111, 3, 1, '205', 'Burwell', 10, TRUE),
       (112, 3, 1, '300', 'Black Tusk', 4, TRUE),
       (113, 3, 1, '301', 'Lions', 16, TRUE),
       (114, 3, 1, '302', 'Brunswick Boardroom Combinable', 22, TRUE),
       (115, 3, 1, '303', 'Capilano Boardroom Combinable', 22, TRUE),
       (116, 3, 1, '400', 'Bugaboo', 5, TRUE),
       (117, 3, 1, '401', 'Seymour', 5, TRUE),
       (118, 3, 2, '100', 'Grouse', 4, TRUE),
       (119, 3, 2, '101', 'Cronin', 6, TRUE),
       (120, 3, 2, '402', 'Castlegar', 14, TRUE),
       (121, 3, 3, '100', 'Tantalus', 6, TRUE),
       (122, 3, 3, '301', 'Lillooet', 6, TRUE),
       (123, 3, 3, '302', 'Coliseum', 5, TRUE),
       (124, 3, 3, '305', '', 4, TRUE),
       (125, 3, 3, '306', '', 4, TRUE),
       (126, 3, 4, '100', 'Harrison', 4, TRUE),
       (127, 3, 4, '201', 'Shuswap', 4, TRUE),
       (128, 3, 4, '202', 'Garibaldi', 4, TRUE),
       (129, 3, 4, '300', 'Alice', 8, TRUE),
       (130, 3, 4, '401', 'Deer', 4, TRUE),
       (131, 3, 4, '402', 'Cultus', 14, TRUE),
       (132, 3, 5, '100', 'Amber', 4, TRUE),
       (133, 3, 5, '101', 'Jade', 6, TRUE),
       (134, 3, 5, '201', 'Opal', 4, TRUE),
       (135, 3, 5, '202', 'Quartz', 4, TRUE),
       (136, 3, 5, '300', 'Topaz', 8, TRUE),
       (137, 3, 5, '401', 'Emerald', 4, TRUE),
       (138, 3, 5, '402', 'Ammolite', 14, TRUE),
       (139, 3, 6, '100', 'Fir', 4, TRUE),
       (140, 3, 6, '201', 'Willow', 4, TRUE),
       (141, 3, 6, '202', 'Spruce', 4, TRUE),
       (142, 3, 6, '300', 'Oak', 8, TRUE),
       (143, 3, 6, '401', 'Pine', 4, TRUE),
       (144, 3, 6, '402', 'Cedar', 14, TRUE),
       (145, 3, 7, '100', 'Waterfront', 4, TRUE),
       (146, 3, 7, '101', 'Vancouver', 4, TRUE),
       (147, 3, 7, '102', 'Olympic', 4, TRUE),
       (148, 3, 7, '300', 'Oakridge', 8, TRUE),
       (149, 3, 7, '301', 'Langara', 10, TRUE),
       (150, 3, 7, '401', 'Broadway', 4, TRUE),
       (151, 3, 7, '402', 'Granville', 14, TRUE);

INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (109, 'AV'),
       (109, 'VC'),
       (110, 'AV'),
       (110, 'VC'),
       (111, 'AV'),
       (111, 'VC'),
       (112, 'AV'),
       (112, 'VC'),
       (113, 'AV'),
       (113, 'VC'),
       (114, 'AV'),
       (114, 'VC'),
       (115, 'AV'),
       (115, 'VC'),
       (118, 'AV'),
       (118, 'VC'),
       (119, 'AV'),
       (119, 'VC'),
       (120, 'AV'),
       (120, 'VC'),
       (121, 'AV'),
       (121, 'VC'),
       (122, 'AV'),
       (122, 'VC'),
       (123, 'AV'),
       (123, 'VC'),
       (124, 'AV'),
       (124, 'VC'),
       (125, 'AV'),
       (125, 'VC'),
       (126, 'AV'),
       (126, 'VC'),
       (127, 'AV'),
       (127, 'VC'),
       (128, 'AV'),
       (128, 'VC'),
       (129, 'AV'),
       (129, 'VC'),
       (130, 'AV'),
       (130, 'VC'),
       (131, 'AV'),
       (131, 'VC'),
       (132, 'AV'),
       (132, 'VC'),
       (133, 'AV'),
       (133, 'VC'),
       (134, 'AV'),
       (134, 'VC'),
       (135, 'AV'),
       (135, 'VC'),
       (136, 'AV'),
       (136, 'VC'),
       (137, 'AV'),
       (137, 'VC'),
       (138, 'AV'),
       (138, 'VC'),
       (139, 'AV'),
       (139, 'VC'),
       (140, 'AV'),
       (140, 'VC'),
       (141, 'AV'),
       (141, 'VC'),
       (142, 'AV'),
       (142, 'VC'),
       (143, 'AV'),
       (143, 'VC'),
       (144, 'AV'),
       (144, 'VC'),
       (145, 'AV'),
       (145, 'VC'),
       (146, 'AV'),
       (146, 'VC'),
       (147, 'AV'),
       (147, 'VC'),
       (148, 'AV'),
       (148, 'VC'),
       (149, 'AV'),
       (149, 'VC'),
       (150, 'AV'),
       (150, 'VC'),
       (151, 'AV'),
       (151, 'VC');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (152, 4, 1, '100', 'Interview Room', 3, TRUE),
       (153, 4, 1, '101', 'Interview Room', 3, TRUE),
       (154, 4, 1, '302', 'Boardroom', 30, TRUE),
       (155, 4, 1, '400', 'Boardroom', 20, TRUE),
       (156, 4, 1, '401', '', 10, TRUE),
       (157, 4, 1, '402', '', 20, TRUE),
       (158, 4, 1, '403', '', 4, TRUE),
       (159, 4, 1, '404', '', 12, TRUE),
       (160, 4, 2, '102', '', 4, TRUE),
       (161, 4, 2, '103', '', 6, TRUE),
       (162, 4, 2, '200', '', 4, TRUE),
       (163, 4, 2, '300', '', 8, TRUE),
       (164, 4, 2, '301', '', 10, TRUE),
       (165, 4, 3, '100', '', 4, TRUE),
       (166, 4, 3, '101', '', 4, TRUE),
       (167, 4, 3, '103', '', 8, TRUE),
       (168, 4, 3, '201', '', 4, TRUE),
       (169, 4, 3, '203', '', 12, TRUE),
       (170, 4, 3, '301', '', 14, TRUE),
       (171, 4, 3, '400', '', 14, TRUE),
       (172, 4, 4, '100', '', 4, TRUE),
       (173, 4, 4, '101', '', 4, TRUE),
       (174, 4, 4, '103', '', 8, TRUE),
       (175, 4, 4, '201', '', 4, TRUE),
       (176, 4, 4, '203', '', 14, TRUE),
       (177, 4, 4, '301', '', 14, TRUE),
       (178, 4, 4, '400', '', 14, TRUE),
       (179, 4, 5, '100', '', 4, TRUE),
       (180, 4, 5, '201', '', 4, TRUE),
       (181, 4, 5, '203', '', 12, TRUE),
       (182, 4, 5, '301', '', 14, TRUE),
       (183, 4, 5, '400', '', 14, TRUE);


INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (154, 'AV'),
       (154, 'VC'),
       (155, 'AV'),
       (155, 'VC'),
       (156, 'AV'),
       (157, 'AV'),
       (158, 'AV'),
       (159, 'AV'),
       (159, 'VC'),
       (160, 'AV'),
       (161, 'AV'),
       (162, 'AV'),
       (163, 'AV'),
       (164, 'AV'),
       (165, 'AV'),
       (166, 'AV'),
       (167, 'AV'),
       (168, 'AV'),
       (169, 'AV'),
       (170, 'AV'),
       (171, 'AV'),
       (172, 'AV'),
       (173, 'AV'),
       (174, 'AV'),
       (175, 'AV'),
       (176, 'AV'),
       (177, 'AV'),
       (178, 'AV'),
       (179, 'AV'),
       (180, 'AV'),
       (181, 'AV'),
       (182, 'AV'),
       (183, 'AV');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (184, 5, 1, '308', '', 4, TRUE),
       (185, 5, 1, '309', '', 10, TRUE),
       (186, 5, 1, '310', '', 20, TRUE),
       (187, 5, 1, '311', '', 4, TRUE),
       (188, 5, 1, '403', '', 4, TRUE),
       (189, 5, 1, '404', '', 8, TRUE),
       (190, 5, 2, '307', '', 10, TRUE),
       (191, 5, 2, '308', '', 20, TRUE),
       (192, 5, 2, '309', '', 4, TRUE),
       (193, 5, 2, '403', '', 4, TRUE),
       (194, 5, 2, '404', '', 10, TRUE),
       (195, 5, 3, '321', '', 4, TRUE),
       (196, 5, 3, '327', '', 12, TRUE),
       (197, 5, 3, '328', '', 4, TRUE),
       (198, 5, 3, '329', '', 12, TRUE),
       (199, 5, 3, '332', 'Training Room Combinable', 30, TRUE),
       (200, 5, 3, '333', 'Training Room Combinable', 30, TRUE),
       (201, 5, 3, '407', '', 4, TRUE),
       (202, 5, 3, '408', '', 12, TRUE),
       (203, 5, 3, '409', '', 4, TRUE),
       (204, 5, 3, '410', '', 12, TRUE),
       (205, 5, 3, '420', '', 4, TRUE),
       (206, 5, 4, '300', '', 10, TRUE),
       (207, 5, 4, '309', '', 10, TRUE),
       (208, 5, 4, '313', '', 4, TRUE),
       (209, 5, 4, '315', '', 16, TRUE),
       (210, 5, 4, '316', '', 12, TRUE),
       (211, 5, 4, '400', '', 10, TRUE),
       (212, 5, 4, '413', '', 4, TRUE),
       (213, 5, 4, '414', '', 4, TRUE),
       (214, 5, 4, '415', 'Training Room Combinable', 30, TRUE),
       (215, 5, 4, '416', 'Training Room Combinable', 30, TRUE),
       (216, 5, 5, '300', 'Training Room Combinable', 30, TRUE),
       (217, 5, 5, '301', 'Training Room Combinable', 30, TRUE),
       (218, 5, 5, '306', '', 4, TRUE),
       (219, 5, 5, '313', '', 12, TRUE),
       (220, 5, 5, '314', '', 12, TRUE),
       (221, 5, 5, '400', '', 16, TRUE),
       (222, 5, 5, '401', '', 20, TRUE),
       (223, 5, 5, '420', '', 4, TRUE),
       (224, 5, 5, '421', '', 4, TRUE),
       (225, 5, 5, '422', '', 8, TRUE),
       (226, 5, 6, '300', 'Training Room Combinable', 30, TRUE),
       (227, 5, 6, '301', 'Training Room Combinable', 30, TRUE),
       (228, 5, 6, '302', 'Training Room', 30, TRUE),
       (229, 5, 6, '303', '', 4, TRUE),
       (230, 5, 6, '304', '', 4, TRUE),
       (231, 5, 6, '306', '', 4, TRUE),
       (232, 5, 6, '314', '', 12, TRUE),
       (233, 5, 6, '315', '', 4, TRUE),
       (234, 5, 6, '316', '', 4, TRUE),
       (235, 5, 6, '400', '', 8, TRUE),
       (236, 5, 6, '401', '', 18, TRUE),
       (237, 5, 6, '419', 'Training Room', 30, TRUE),
       (238, 5, 7, '300', '', 20, TRUE),
       (239, 5, 7, '305', '', 14, TRUE),
       (240, 5, 7, '312', '', 8, TRUE),
       (241, 5, 7, '313', '', 12, TRUE),
       (242, 5, 7, '314', '', 12, TRUE),
       (243, 5, 7, '401', '', 4, TRUE),
       (244, 5, 7, '402', '', 14, TRUE),
       (245, 5, 7, '403', '', 10, TRUE),
       (246, 5, 7, '404', '', 4, TRUE),
       (247, 5, 7, '405', '', 4, TRUE),
       (248, 5, 7, '424', '', 4, TRUE),
       (249, 5, 8, '300', '', 20, TRUE),
       (250, 5, 8, '312', '', 8, TRUE),
       (251, 5, 8, '313', '', 12, TRUE),
       (252, 5, 8, '314', '', 12, TRUE),
       (253, 5, 8, '401', '', 4, TRUE),
       (254, 5, 8, '402', '', 14, TRUE),
       (255, 5, 8, '403', '', 10, TRUE),
       (256, 5, 8, '404', '', 4, TRUE),
       (257, 5, 8, '405', '', 4, TRUE),
       (258, 5, 8, '424', '', 4, TRUE),
       (259, 5, 9, '300', '', 20, TRUE),
       (260, 5, 9, '305', '', 14, TRUE),
       (261, 5, 9, '312', '', 8, TRUE),
       (262, 5, 9, '313', '', 12, TRUE),
       (263, 5, 9, '314', '', 12, TRUE),
       (264, 5, 9, '401', '', 4, TRUE),
       (265, 5, 9, '402', '', 14, TRUE),
       (266, 5, 9, '403', '', 10, TRUE),
       (267, 5, 9, '404', '', 4, TRUE),
       (268, 5, 9, '405', '', 4, TRUE),
       (269, 5, 9, '424', '', 4, TRUE),
       (270, 5, 10, '300', '', 20, TRUE),
       (271, 5, 10, '312', '', 8, TRUE),
       (272, 5, 10, '313', '', 12, TRUE),
       (273, 5, 10, '314', '', 12, TRUE),
       (274, 5, 10, '401', '', 4, TRUE),
       (275, 5, 10, '402', '', 14, TRUE),
       (276, 5, 10, '403', '', 10, TRUE),
       (277, 5, 10, '404', '', 4, TRUE),
       (278, 5, 10, '405', '', 4, TRUE),
       (279, 5, 10, '424', '', 4, TRUE),
       (280, 5, 11, '300', '', 20, TRUE),
       (281, 5, 11, '314', '', 12, TRUE),
       (282, 5, 11, '403', '', 10, TRUE),
       (283, 5, 11, '404', '', 4, TRUE);

INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (184, 'AV'),
       (184, 'VC'),
       (185, 'AV'),
       (185, 'VC'),
       (186, 'AV'),
       (186, 'VC'),
       (187, 'AV'),
       (187, 'VC'),
       (188, 'AV'),
       (188, 'VC'),
       (189, 'AV'),
       (189, 'VC'),
       (190, 'AV'),
       (190, 'VC'),
       (191, 'AV'),
       (191, 'VC'),
       (192, 'AV'),
       (192, 'VC'),
       (193, 'AV'),
       (193, 'VC'),
       (194, 'AV'),
       (194, 'VC'),
       (195, 'AV'),
       (195, 'VC'),
       (196, 'AV'),
       (196, 'VC'),
       (197, 'AV'),
       (197, 'VC'),
       (198, 'AV'),
       (198, 'VC'),
       (199, 'AV'),
       (199, 'VC'),
       (200, 'AV'),
       (200, 'VC'),
       (201, 'AV'),
       (201, 'VC'),
       (202, 'AV'),
       (202, 'VC'),
       (203, 'AV'),
       (203, 'VC'),
       (204, 'AV'),
       (204, 'VC'),
       (205, 'AV'),
       (205, 'VC'),
       (206, 'AV'),
       (206, 'VC'),
       (207, 'AV'),
       (207, 'VC'),
       (208, 'AV'),
       (208, 'VC'),
       (209, 'AV'),
       (209, 'VC'),
       (210, 'AV'),
       (210, 'VC'),
       (211, 'AV'),
       (211, 'VC'),
       (212, 'AV'),
       (212, 'VC'),
       (213, 'AV'),
       (213, 'VC'),
       (214, 'AV'),
       (214, 'VC'),
       (215, 'AV'),
       (215, 'VC'),
       (216, 'AV'),
       (216, 'VC'),
       (217, 'AV'),
       (217, 'VC'),
       (218, 'AV'),
       (218, 'VC'),
       (219, 'AV'),
       (219, 'VC'),
       (220, 'AV'),
       (220, 'VC'),
       (221, 'AV'),
       (221, 'VC'),
       (222, 'AV'),
       (222, 'VC'),
       (223, 'AV'),
       (223, 'VC'),
       (224, 'AV'),
       (224, 'VC'),
       (225, 'AV'),
       (225, 'VC'),
       (226, 'AV'),
       (226, 'VC'),
       (227, 'AV'),
       (227, 'VC'),
       (228, 'AV'),
       (228, 'VC'),
       (229, 'AV'),
       (229, 'VC'),
       (230, 'AV'),
       (230, 'VC'),
       (231, 'AV'),
       (231, 'VC'),
       (232, 'AV'),
       (232, 'VC'),
       (233, 'AV'),
       (233, 'VC'),
       (234, 'AV'),
       (234, 'VC'),
       (235, 'AV'),
       (235, 'VC'),
       (236, 'AV'),
       (236, 'VC'),
       (237, 'AV'),
       (237, 'VC'),
       (238, 'AV'),
       (238, 'VC'),
       (239, 'AV'),
       (239, 'VC'),
       (240, 'AV'),
       (240, 'VC'),
       (241, 'AV'),
       (241, 'VC'),
       (242, 'AV'),
       (242, 'VC'),
       (243, 'AV'),
       (243, 'VC'),
       (244, 'AV'),
       (244, 'VC'),
       (245, 'AV'),
       (245, 'VC'),
       (246, 'AV'),
       (246, 'VC'),
       (247, 'AV'),
       (247, 'VC'),
       (248, 'AV'),
       (248, 'VC'),
       (249, 'AV'),
       (249, 'VC'),
       (250, 'AV'),
       (250, 'VC'),
       (251, 'AV'),
       (251, 'VC'),
       (252, 'AV'),
       (252, 'VC'),
       (253, 'AV'),
       (253, 'VC'),
       (254, 'AV'),
       (254, 'VC'),
       (255, 'AV'),
       (255, 'VC'),
       (256, 'AV'),
       (256, 'VC'),
       (257, 'AV'),
       (257, 'VC'),
       (258, 'AV'),
       (258, 'VC'),
       (259, 'AV'),
       (259, 'VC'),
       (260, 'AV'),
       (260, 'VC'),
       (261, 'AV'),
       (261, 'VC'),
       (262, 'AV'),
       (262, 'VC'),
       (263, 'AV'),
       (263, 'VC'),
       (264, 'AV'),
       (264, 'VC'),
       (265, 'AV'),
       (265, 'VC'),
       (266, 'AV'),
       (266, 'VC'),
       (267, 'AV'),
       (267, 'VC'),
       (268, 'AV'),
       (268, 'VC'),
       (269, 'AV'),
       (269, 'VC'),
       (270, 'AV'),
       (270, 'VC'),
       (271, 'AV'),
       (271, 'VC'),
       (272, 'AV'),
       (272, 'VC'),
       (273, 'AV'),
       (273, 'VC'),
       (274, 'AV'),
       (274, 'VC'),
       (275, 'AV'),
       (275, 'VC'),
       (276, 'AV'),
       (276, 'VC'),
       (277, 'AV'),
       (277, 'VC'),
       (278, 'AV'),
       (278, 'VC'),
       (279, 'AV'),
       (279, 'VC'),
       (280, 'AV'),
       (280, 'VC'),
       (281, 'AV'),
       (281, 'VC'),
       (282, 'AV'),
       (282, 'VC'),
       (283, 'AV'),
       (283, 'VC');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (284, 6, 1, '100', '', 18, TRUE),
       (285, 6, 1, '101', '', 18, TRUE),
       (286, 6, 1, '102', '', 4, TRUE),
       (287, 6, 1, '103', '', 4, TRUE),
       (288, 6, 1, '104', '', 4, TRUE),
       (289, 6, 1, '105', '', 14, TRUE),
       (290, 6, 1, '406', '', 10, TRUE),
       (291, 6, 2, '100', '', 18, TRUE),
       (292, 6, 2, '101', '', 18, TRUE),
       (293, 6, 2, '102', '', 4, TRUE),
       (294, 6, 2, '103', '', 4, TRUE),
       (295, 6, 2, '104', '', 4, TRUE),
       (296, 6, 2, '105', '', 14, TRUE),
       (297, 6, 2, '406', '', 10, TRUE),
       (298, 6, 3, '100', 'Sunnyside', 12, TRUE),
       (299, 6, 3, '103', 'Hanlan''s Point', 18, TRUE),
       (300, 6, 3, '104', 'Gibraltar Point', 4, TRUE),
       (301, 6, 3, '105', 'Centre Island', 4, TRUE),
       (302, 6, 3, '106', 'Ward''s Island', 18, TRUE),
       (303, 6, 3, '107', 'Cherry', 14, TRUE),
       (304, 6, 3, '108', 'Woodbine', 10, TRUE),
       (305, 6, 3, '401', 'Kew Balmy', 4, TRUE),
       (306, 6, 4, '100', 'Liberty Village', 12, TRUE),
       (307, 6, 4, '103', 'Conference Room', 18, TRUE),
       (308, 6, 4, '104', 'Corktown', 4, TRUE),
       (309, 6, 4, '105', 'Riverdale', 4, TRUE),
       (310, 6, 4, '106', 'Cabbagetown', 18, TRUE),
       (311, 6, 4, '107', 'Danforth', 14, TRUE),
       (312, 6, 4, '108', 'Rosedale', 10, TRUE),
       (313, 6, 4, '401', 'Yorkville', 4, TRUE),
       (314, 6, 4, '402', 'Junction Casual', 4, TRUE),
       (315, 6, 5, '103', 'Yonge Boardroom Combinable', 32, TRUE),
       (316, 6, 5, '104', 'Adelaide Boardroom Combinable', 32, TRUE),
       (317, 6, 5, '105', 'Eglinton', 4, TRUE),
       (318, 6, 5, '201', 'Public - Queen', 16, TRUE),
       (319, 6, 5, '204', 'Front', 16, TRUE),
       (320, 6, 5, '205', 'Bay', 16, TRUE),
       (321, 6, 6, '100', 'Kipling', 12, TRUE),
       (322, 6, 6, '103', 'Islington', 18, TRUE),
       (323, 6, 6, '104', 'Bloor', 4, TRUE),
       (324, 6, 6, '105', 'Broadview', 4, TRUE),
       (325, 6, 6, '106', 'St. George', 18, TRUE),
       (326, 6, 6, '107', 'Downsview', 14, TRUE),
       (327, 6, 6, '108', 'Finch', 10, TRUE),
       (328, 6, 6, '401', 'Dundas', 4, TRUE),
       (329, 6, 6, '402', 'Union Casual', 4, TRUE),
       (330, 6, 7, '100', 'Canoe', 12, TRUE),
       (331, 6, 7, '103', 'Smoke', 18, TRUE),
       (332, 6, 7, '104', 'Cache', 4, TRUE),
       (333, 6, 7, '105', 'Madawaska', 4, TRUE),
       (334, 6, 7, '106', 'Petawawa', 18, TRUE),
       (335, 6, 7, '107', 'Teepee', 14, TRUE),
       (336, 6, 7, '108', 'Big Trout', 10, TRUE),
       (337, 6, 7, '401', 'Manitou', 4, TRUE),
       (338, 6, 7, '402', 'Opeongo Casual', 4, TRUE);

INSERT INTO rooms_equipments (room_id, equipment_id)
VALUES (284, 'AV'),
       (284, 'VC'),
       (285, 'AV'),
       (285, 'VC'),
       (286, 'AV'),
       (286, 'VC'),
       (287, 'AV'),
       (287, 'VC'),
       (288, 'AV'),
       (288, 'VC'),
       (289, 'AV'),
       (289, 'VC'),
       (290, 'AV'),
       (290, 'VC'),
       (291, 'AV'),
       (291, 'VC'),
       (292, 'AV'),
       (292, 'VC'),
       (293, 'AV'),
       (293, 'VC'),
       (294, 'AV'),
       (294, 'VC'),
       (295, 'AV'),
       (295, 'VC'),
       (296, 'AV'),
       (296, 'VC'),
       (297, 'AV'),
       (297, 'VC'),
       (298, 'AV'),
       (298, 'VC'),
       (299, 'AV'),
       (299, 'VC'),
       (300, 'AV'),
       (300, 'VC'),
       (301, 'AV'),
       (301, 'VC'),
       (302, 'AV'),
       (302, 'VC'),
       (303, 'AV'),
       (303, 'VC'),
       (304, 'AV'),
       (304, 'VC'),
       (305, 'AV'),
       (305, 'VC'),
       (306, 'AV'),
       (306, 'VC'),
       (308, 'AV'),
       (308, 'VC'),
       (309, 'AV'),
       (309, 'VC'),
       (310, 'AV'),
       (310, 'VC'),
       (311, 'AV'),
       (311, 'VC'),
       (312, 'AV'),
       (312, 'VC'),
       (315, 'AV'),
       (315, 'VC'),
       (316, 'AV'),
       (316, 'VC'),
       (317, 'AV'),
       (317, 'VC'),
       (319, 'AV'),
       (319, 'VC'),
       (320, 'AV'),
       (320, 'VC'),
       (321, 'AV'),
       (321, 'VC'),
       (322, 'AV'),
       (322, 'VC'),
       (323, 'AV'),
       (323, 'VC'),
       (324, 'AV'),
       (324, 'VC'),
       (325, 'AV'),
       (325, 'VC'),
       (326, 'AV'),
       (326, 'VC'),
       (327, 'AV'),
       (327, 'VC'),
       (330, 'AV'),
       (330, 'VC'),
       (331, 'AV'),
       (331, 'VC'),
       (332, 'AV'),
       (332, 'VC'),
       (333, 'AV'),
       (333, 'VC'),
       (334, 'AV'),
       (334, 'VC'),
       (335, 'AV'),
       (335, 'VC'),
       (336, 'AV'),
       (336, 'VC'),
       (338, 'AV'),
       (338, 'VC');

INSERT INTO rooms (room_id, building_id, floor, code, name, seats, is_active)
VALUES (339, 7, 1, '007.A', '', 10, TRUE),
       (340, 7, 1, '007.B', '', 2, TRUE),
       (341, 7, 1, '007.C', '', 2, TRUE),
       (342, 7, 7, '007.D', '', 2, TRUE),
       (343, 7, 2, 'A', 'Conference', 10, TRUE),
       (344, 7, 2, 'B', 'Huddle', 4, TRUE),
       (345, 7, 2, 'C', 'Huddle', 4, TRUE),
       (346, 7, 2, 'D', 'Conference', 5, TRUE),
       (347, 7, 2, 'E', 'Conference', 5, TRUE),
       (348, 7, 2, 'F', 'Conference', 5, TRUE);

SELECT setval('rooms_room_id_seq', (SELECT MAX(room_id) FROM rooms));

INSERT INTO users (user_id, username, first_name, last_name, email, building_id, floor, desk, role, is_active)
VALUES (1, 'team7awsome01', 'AdminOne', 'Test', 'team7awsome01@gmail.com', 1, 10, 100, 'admin', TRUE),
       (2, 'team7awsome02', 'AdminTwo', 'Test', 'team7awsome02@gmail.com', 2, 3, 100, 'admin', TRUE),
       (3, 'team7awsome098', 'AdminThree', 'Test', 'team7awsome98@gmail.com', 3, 5, 100, 'admin', TRUE),
       (4, 'team7awsomeuser01', 'StaffOne', 'Test', 'team7awsomeuser01@gmail.com', 4, 2, 100, 'staff', TRUE),
       (5, 'team7awsomeuser12', 'StaffTwo', 'Test', 'team7awsomeuser12@gmail.com', 5, 4, 100, 'staff', TRUE),
       (6, 'team7awsomeuser22', 'StaffThree', 'Test', 'team7awsomeuser22@gmail.com', 5, 6, 100, 'staff', TRUE),
       (7, 'YVR32_01_1', 'First', 'Last', 'YVR32_01_1@aws.ca', 1, 1, 100, 'staff', TRUE),
       (8, 'YVR32_01_2', 'First', 'Last', 'YVR32_01_2@aws.ca', 1, 1, 100, 'staff', TRUE),
       (9, 'YVR32_01_off', 'First', 'Last', 'YVR32_01_off@aws.ca', 1, 1, 100, 'staff', FALSE),
       (10, 'YVR32_03_1', 'First', 'Last', 'YVR32_03_1@aws.ca', 1, 3, 100, 'staff', TRUE),
       (11, 'YVR32_05_1', 'First', 'Last', 'YVR32_05_1@aws.ca', 1, 5, 100, 'staff', TRUE),
       (12, 'YVR41_01_1', 'First', 'Last', 'YVR41_01_1@aws.ca', 2, 1, 100, 'staff', TRUE),
       (13, 'YVR41_01_2', 'First', 'Last', 'YVR41_01_2@aws.ca', 2, 1, 100, 'staff', TRUE),
       (14, 'YVR41_05_1', 'First', 'Last', 'YVR41_05_1@aws.ca', 2, 5, 100, 'staff', TRUE),
       (15, 'YVR74_01_1', 'First', 'Last', 'YVR74_01_1@aws.ca', 3, 1, 100, 'staff', TRUE),
       (16, 'YVR74_01_2', 'First', 'Last', 'YVR74_01_2@aws.ca', 3, 1, 100, 'staff', TRUE),
       (17, 'YVR74_01_3', 'First', 'Last', 'YVR74_01_3@aws.ca', 3, 1, 100, 'staff', TRUE),
       (18, 'YVR63_01_1', 'First', 'Last', 'YVR63_01_1@aws.ca', 4, 1, 100, 'staff', TRUE),
       (19, 'YVR63_01_2', 'First', 'Last', 'YVR63_01_2@aws.ca', 4, 1, 100, 'staff', TRUE),
       (20, 'YVR63_01_3', 'First', 'Last', 'YVR63_01_3@aws.ca', 4, 1, 100, 'staff', TRUE),
       (21, 'YVR73_01_1', 'First', 'Last', 'YVR73_01_1@aws.ca', 5, 1, 100, 'staff', TRUE),
       (22, 'YVR73_01_2', 'First', 'Last', 'YVR73_01_2@aws.ca', 5, 1, 100, 'staff', TRUE),
       (23, 'YVR73_01_3', 'First', 'Last', 'YVR73_01_3@aws.ca', 5, 1, 100, 'staff', TRUE),
       (24, 'YYZ34_01_1', 'First', 'Last', 'YYZ34_01_1@aws.ca', 6, 1, 100, 'staff', TRUE),
       (25, 'YYZ34_01_2', 'First', 'Last', 'YYZ34_01_2@aws.ca', 6, 1, 100, 'staff', TRUE),
       (26, 'YYZ34_01_3', 'First', 'Last', 'YYZ34_01_3@aws.ca', 6, 1, 100, 'staff', TRUE),
       (27, 'YUL22_01_1', 'First', 'Last', 'YUL22_01_1@aws.ca', 7, 1, 100, 'staff', TRUE),
       (28, 'YUL22_01_2', 'First', 'Last', 'YUL22_01_2@aws.ca', 7, 1, 100, 'staff', TRUE),
       (29, 'YUL22_01_3', 'First', 'Last', 'YUL22_01_3@aws.ca', 7, 1, 100, 'staff', TRUE);

SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users));

INSERT INTO distances (building_id_from, building_id_to, distance)
VALUES (1, 1, 0),
       (1, 2, 6225),
       (1, 3, 11241),
       (1, 4, 14217),
       (1, 5, 24377),
       (2, 1, 6225),
       (2, 2, 0),
       (2, 3, 15873),
       (2, 4, 20075),
       (2, 5, 27138),
       (3, 1, 11241),
       (3, 2, 15873),
       (3, 3, 0),
       (3, 4, 15727),
       (3, 5, 14165),
       (4, 1, 14217),
       (4, 2, 20075),
       (4, 3, 15727),
       (4, 4, 0),
       (4, 5, 29006),
       (5, 1, 24377),
       (5, 2, 27138),
       (5, 3, 14165),
       (5, 4, 29006),
       (5, 5, 0),
       (6, 6, 0),
       (7, 7, 0);
