USE clean_air_corp;

-- 1. DEPARTMENT  (initially eSSN = NULL, managers set later)
INSERT INTO Department (dept_id, dept_name, dept_location, eSSN) VALUES
(1,  'Administration',      'Head Office',        NULL),
(2,  'Engineering',         'Plant A',            NULL),
(3,  'Metal Fabrication',   'Plant A - Bay 1',    NULL),
(4,  'Plastic Fabrication', 'Plant A - Bay 2',    NULL),
(5,  'Sales',               'Head Office - 2F',   NULL),
(6,  'Maintenance',         'Plant A - Shop',     NULL),
(7,  'Logistics',           'Warehouse East',     NULL),
(8,  'Quality Control',     'Plant A - Lab',      NULL),
(9,  'Research & Dev',      'Innovation Center',  NULL),
(10, 'IT Support',          'Head Office - 3F',   NULL);

-- 2. CUSTOMER
INSERT INTO Customer (customer_id, customer_name) VALUES
(1,  'Omega Foods Inc.'),
(2,  'Crystal Glassworks'),
(3,  'Nova Chemicals LLC'),
(4,  'Ironclad Metals'),
(5,  'BlueSky Beverages'),
(6,  'GreenFarm Produce'),
(7,  'Northern Steel Co.'),
(8,  'Metro Plastics Corp.'),
(9,  'Sunrise Pharma'),
(10, 'Harbor Shipyards');

-- 3. VENDOR
INSERT INTO Vendor (vendor_id, vendor_name) VALUES
(1,  'SteelSource Ltd.'),
(2,  'Precision Plastics'),
(3,  'FilterMedia Supply'),
(4,  'AirFlow Components'),
(5,  'TankWorks Industrial'),
(6,  'RapidFasteners Co.'),
(7,  'PowerDrive Motors'),
(8,  'SafeSeal Gaskets'),
(9,  'CleanChem Solvents'),
(10, 'MegaMetals Group');

-- 4. PRODUCT_DETAIL
INSERT INTO Product_Detail (product_num, unit_info, unit_status) VALUES
(1001, 'CAR-1001 Cartridge Filter Housing',             'In Stock'),
(1002, 'BAG-2201 Baghouse Dust Collector',              'In Production'),
(1003, 'SCR-3100 Scrubber Unit - Medium',               'In Stock'),
(1004, 'FAN-4500 High-CFM Exhaust Fan',                 'Reserved'),
(1005, 'TK-6000 Stainless Steel Storage Tank',          'In Stock'),
(1006, 'CAR-1100 High-Efficiency Filter Cartridge',     'In Stock'),
(1007, 'DCT-500 Portable Dust Collector',               'In Production'),
(1008, 'SCR-3200 Scrubber Unit - Large',                'In Stock'),
(1009, 'FAN-4600 Variable-Speed Fan Assembly',          'In Stock'),
(1010,'TK-6100 High-Pressure Process Tank',             'Reserved'),
(1011,'CAR-1200 Compact Filter Housing',                'In Stock'),
(1012,'BAG-2300 High-Capacity Baghouse',                'In Production'),
(1013,'SCR-3300 Corrosive Gas Scrubber',                'In Stock'),
(1014,'FAN-4700 Low-Noise Exhaust Fan',                 'In Stock'),
(1015,'TK-6200 Jacketed Process Tank',                  'In Stock'),
(1016,'CAR-1300 Ultra-Fine Filter Cartridge',           'In Stock'),
(1017,'DCT-600 Mobile Dust Collector',                  'In Production'),
(1018,'SCR-3400 High-Temperature Scrubber',             'In Stock'),
(1019,'FAN-4800 Explosion-Proof Fan',                   'Reserved'),
(1020,'TK-6300 Underground Storage Tank',               'In Stock');

-- 5. EMPLOYEE 
INSERT INTO Employee (ssn, name, dept_id, dob) VALUES
('100000001', 'Alice Johnson',       1, '1985-03-12'),
('100000002', 'Brian Smith',         2, '1979-11-05'),
('100000003', 'Carla Rodriguez',     3, '1990-07-21'),
('100000004', 'David Kim',           4, '1988-01-30'),
('100000005', 'Evelyn Brown',        5, '1982-09-14'),
('100000006', 'Frank Wilson',        6, '1977-05-18'),
('100000007', 'Grace Lee',           7, '1993-02-08'),
('100000008', 'Henry Thompson',      8, '1986-06-25'),
('100000009', 'Isabella Martinez',   9, '1995-04-03'),
('100000010', 'Jack Peterson',      10, '1980-12-19'),
('100000011', 'Liam Anderson',       1, '1987-07-02'),
('100000012', 'Mia Nguyen',          2, '1992-10-11'),
('100000013', 'Noah Walker',         3, '1984-01-09'),
('100000014', 'Olivia Harris',       4, '1991-05-27'),
('100000015', 'Paul Green',          5, '1989-09-03'),
('100000016', 'Quinn Foster',        6, '1983-12-28'),
('100000017', 'Ruby Collins',        7, '1994-06-14'),
('100000018', 'Samuel Wright',       8, '1981-02-20'),
('100000019', 'Taylor Brooks',       5, '1996-11-30'),
('100000020', 'Uma Patel',          10, '1990-08-18');

-- 6. MAINTENANCE_SERVICE 
INSERT INTO Maintenance_Service (job_num, date, job_type, product_num, eSSN) VALUES
(2001, '2025-01-05', 'Installation Check',       1001, '100000006'),
(2002, '2025-01-08', 'Routine Inspection',       1002, '100000006'),
(2003, '2025-01-12', 'Filter Replacement',       1003, '100000016'),
(2004, '2025-01-15', 'Fan Alignment',            1004, '100000006'),
(2005, '2025-01-18', 'Tank Pressure Test',       1005, '100000016'),
(2006, '2025-01-20', 'Startup Support',          1006, '100000006'),
(2007, '2025-01-22', 'Dust Collector Cleaning',  1007, '100000016'),
(2008, '2025-01-25', 'Performance Audit',        1008, '100000008'),
(2009, '2025-01-28', 'Noise Investigation',      1009, '100000008'),
(2010, '2025-01-30', 'Annual Service',           1010, '100000008'),
(2011, '2025-02-02', 'Leak Detection',           1011, '100000006'),
(2012, '2025-02-04', 'Filter Media Upgrade',     1012, '100000016'),
(2013, '2025-02-06', 'Corrosion Check',          1013, '100000008'),
(2014, '2025-02-08', 'Fan Bearing Replacement',  1014, '100000006'),
(2015, '2025-02-10', 'Tank Cleaning',            1015, '100000016');

-- 7. PRODUCT_SALES 
INSERT INTO Product_Sales (sale_id, product_num, customer_id, job_num, eSSN, date) VALUES
(3001, 1001,  1,  2001, '100000005', '2025-02-10'),
(3002, 1002,  2,  2002, '100000005', '2025-02-11'),
(3003, 1003,  3,  NULL, '100000015', '2025-02-13'),
(3004, 1004,  4,  2004, '100000019', '2025-02-15'),
(3005, 1005,  5,  2005, '100000015', '2025-02-17'),
(3006, 1006,  6,  NULL, '100000005', '2025-02-19'),
(3007, 1007,  7,  2007, '100000019', '2025-02-21'),
(3008, 1008,  8,  2008, '100000005', '2025-02-23'),
(3009, 1009,  9,  NULL, '100000015', '2025-02-25'),
(3010, 1010, 10, 2010, '100000019', '2025-02-27'),
(3011, 1011,  1, 2011, '100000005', '2025-03-01'),
(3012, 1012,  2, NULL, '100000015', '2025-03-03'),
(3013, 1013,  3, 2013, '100000019', '2025-03-05'),
(3014, 1014,  4, NULL, '100000005', '2025-03-07'),
(3015, 1015,  5, 2015, '100000015', '2025-03-09');

-- 8. SHIPMENT 
INSERT INTO Shipment (order_id, sale_id, customer, address, ETA) VALUES
(4001, 3001, 'Omega Foods Inc.',        '1200 Grain Rd, Valley City, MI',  '2025-02-17'),
(4002, 3002, 'Crystal Glassworks',      '45 Furnace Ave, Crystal Bay, MI', '2025-02-18'),
(4003, 3003, 'Nova Chemicals LLC',      '900 Reactor Dr, ChemVille, MI',   '2025-02-20'),
(4004, 3004, 'Ironclad Metals',         '300 Steel Mill Ln, Ironport, MI', '2025-02-22'),
(4005, 3005, 'BlueSky Beverages',       '77 Bottling Way, Freshwater, MI', '2025-02-24'),
(4006, 3006, 'GreenFarm Produce',       '18 Harvest Rd, Meadowtown, MI',   '2025-02-26'),
(4007, 3007, 'Northern Steel Co.',      '550 Forge St, Northgate, MI',     '2025-02-28'),
(4008, 3008, 'Metro Plastics Corp.',    '821 Polymer Pkwy, Metro City, MI','2025-03-02'),
(4009, 3009, 'Sunrise Pharma',          '210 Lab Dr, MedCity, MI',         '2025-03-04'),
(4010, 3010, 'Harbor Shipyards',        '5 Dockside Way, Harbor Town, MI', '2025-03-06'),
(4011, 3011, 'Omega Foods Inc.',        '1200 Grain Rd, Valley City, MI',  '2025-03-08'),
(4012, 3012, 'Crystal Glassworks',      '45 Furnace Ave, Crystal Bay, MI', '2025-03-10'),
(4013, 3013, 'Nova Chemicals LLC',      '900 Reactor Dr, ChemVille, MI',   '2025-03-12'),
(4014, 3014, 'Ironclad Metals',         '300 Steel Mill Ln, Ironport, MI', '2025-03-14'),
(4015, 3015, 'BlueSky Beverages',       '77 Bottling Way, Freshwater, MI', '2025-03-16');

-- 9. PURCHASING 
INSERT INTO Purchasing (product_number, vendor_id, eSSN, date) VALUES
(1001,  1, '100000002', '2024-12-01'),
(1002,  1, '100000012', '2024-12-03'),
(1003,  2, '100000003', '2024-12-05'),
(1004,  2, '100000013', '2024-12-07'),
(1005,  3, '100000004', '2024-12-09'),
(1006,  3, '100000014', '2024-12-11'),
(1007,  4, '100000007', '2024-12-13'),
(1008,  4, '100000017', '2024-12-15'),
(1009,  5, '100000009', '2024-12-17'),
(1010,  5, '100000011', '2024-12-19'),
(1011,  6, '100000018', '2024-12-21'),
(1012,  6, '100000016', '2024-12-23'),
(1013,  7, '100000006', '2024-12-27'),
(1014,  8, '100000001', '2024-12-29'),
(1015,  9, '100000020', '2024-12-30'),
(1016, 10,'100000010', '2024-12-31');

-- 10. ASSIGN MANAGERS AFTER EMPLOYEES EXIST
UPDATE Department SET eSSN = '100000001' WHERE dept_id = 1;   
UPDATE Department SET eSSN = '100000002' WHERE dept_id = 2;   
UPDATE Department SET eSSN = '100000003' WHERE dept_id = 3;   
UPDATE Department SET eSSN = '100000004' WHERE dept_id = 4;   
UPDATE Department SET eSSN = '100000005' WHERE dept_id = 5;   
UPDATE Department SET eSSN = '100000006' WHERE dept_id = 6;  
UPDATE Department SET eSSN = '100000007' WHERE dept_id = 7;  
UPDATE Department SET eSSN = '100000008' WHERE dept_id = 8;   
UPDATE Department SET eSSN = '100000009' WHERE dept_id = 9;   
UPDATE Department SET eSSN = '100000010' WHERE dept_id = 10;  