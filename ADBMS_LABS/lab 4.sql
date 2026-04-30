-- ============================================
-- COMPLETE LAB SCRIPT - RUN IN ORDER
-- ============================================

-- Step 1: Create Tables
CREATE TABLE Branch (
    branchno VARCHAR(10) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(20)
);

CREATE TABLE Staff (
    staffno VARCHAR(10) PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50),
    position VARCHAR(50),
    sex CHAR(1),
    dob DATE,
    salary INT,
    branchno VARCHAR(10),
    FOREIGN KEY (branchno) REFERENCES Branch(branchno)
);

CREATE TABLE PropertyForRent (
    propertyno VARCHAR(10) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(20),
    type VARCHAR(20),
    rooms INT,
    rent INT,
    staffno VARCHAR(10),
    FOREIGN KEY (staffno) REFERENCES Staff(staffno)
);

-- Step 2: Insert Data into Branch
INSERT INTO Branch VALUES 
('B005', '22 Deer Rd', 'London', 'SW1 4EH'),
('B007', '16 Argyll St', 'Aberdeen', 'AB2 3SU'),
('B003', '163 Main St', 'Glasgow', 'G11 9QB'),
('B004', '32 Manse Rd', 'Bristol', 'B599 1NZ'),
('B002', '56 Clover Dr', 'London', 'NW10 6EU');

-- Step 3: Insert Data into Staff
INSERT INTO Staff VALUES 
('SL21', 'John', 'White', 'Manager', 'M', '1945-10-01', 30000, 'B005'),
('SG37', 'Ann', 'Beech', 'Assistant', 'F', '1960-11-10', 12000, 'B003'),
('SG14', 'David', 'Ford', 'Supervisor', 'M', '1958-11-24', 18000, 'B003'),
('SA9', 'Mary', 'Howe', 'Assistant', 'F', '1970-02-19', 9000, 'B007'),
('SG5', 'Susan', 'Brand', 'Manager', 'F', '1940-06-03', 24000, 'B003'),
('SL41', 'Julie', 'Lee', 'Assistant', 'F', '1965-06-13', 9000, 'B005');

-- Step 4: Insert Data into PropertyForRent
INSERT INTO PropertyForRent VALUES 
('PG36', '165 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', 4, 450, NULL),
('PG21', '118 Dale Rd', 'Glasgow', 'G12', 'House', 5, 600, NULL),
('PG3', '62 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', 3, 375, NULL);

-- ============================================
-- ALL LAB QUERIES
-- ============================================

-- Query 1: Staff at '163 Main St' (JOIN method) - Page 5
SELECT staff.* 
FROM staff
JOIN branch ON staff.branchno = branch.branchno 
WHERE branch.street = '163 Main St';

-- Query 2: Staff at '163 Main St' (Subquery method) - Page 6
SELECT * 
FROM staff 
WHERE branchno = (SELECT branchno FROM branch WHERE street = '163 Main St');

-- Query 3: Branch number and city (salary > 10000) - JOIN - Page 7
SELECT DISTINCT branch.branchno, branch.city 
FROM branch
JOIN staff ON branch.branchno = staff.branchno 
WHERE staff.salary > 10000;

-- Query 4: Branch number and city (salary > 10000) - Subquery - Page 7
SELECT branch.branchno, branch.city 
FROM branch 
WHERE branch.branchno IN (SELECT branchno FROM staff WHERE salary > 10000);

-- Query 5: Create staff2 table - Page 8
CREATE TABLE staff2 AS
SELECT * FROM staff WHERE position = 'Assistant' OR position = 'Supervisor';

-- Query 6: View staff2 data - Page 8
SELECT * FROM staff2;

-- Query 7: Update staff2 (add 5000 to below average salary) - Page 9
UPDATE staff2 
SET salary = salary + 5000 
WHERE salary < (SELECT AVG(salary) FROM staff2);

-- Query 8: View updated staff2 - Page 9
SELECT * FROM staff2;

-- Query 9: Delete staff from London branches - Page 10
DELETE FROM staff2 
WHERE branchno IN (SELECT branchno FROM branch WHERE city = 'London');

-- Query 10: View staff2 after delete - Page 10
SELECT * FROM staff2;

-- Query 11: Single row subquery - Page 11
SELECT * 
FROM staff 
WHERE branchno = (SELECT branchno FROM branch WHERE street = '163 Main St');

-- Query 12: Multiple row subquery - Page 12
SELECT branch.branchno, branch.city 
FROM branch 
WHERE branch.branchno IN (SELECT branchno FROM staff WHERE salary > 10000);

-- Query 13: Nested subqueries (2 levels) - Page 13
SELECT propertyno, street, city, postcode, type, rooms, rent
FROM propertyforrent
WHERE staffno IN (
    SELECT staffno FROM staff
    WHERE branchno = (
        SELECT branchno FROM branch
        WHERE street = '163 Main St'
    )
);

-- Query 14: ALL operator - Salary > all at branch B003 - Page 15
SELECT staffno, fname, lname, position, salary 
FROM staff 
WHERE salary > ALL (SELECT salary FROM staff WHERE branchno = 'B003');

-- ============================================
-- CLEANUP (Optional - Drop staff2 table)
-- ============================================
DROP TABLE IF EXISTS staff2;