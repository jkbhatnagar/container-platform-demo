-- =========================================================
-- Customer Complaints Management System
-- Complete MySQL Deployment Script
-- Creates the database
-- Creates tables with relationships & constraints
-- Inserts sample data
-- Adds views for easy reporting
-- Defines stored procedures for controlled operations
-- Creates triggers for automatic audit logging
-- =========================================================

-- 1. Create Database
DROP DATABASE IF EXISTS complaints_db;
CREATE DATABASE complaints_db;
USE complaints_db;

-- 2. Create Tables
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('customer', 'staff', 'manager') NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE Complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    attachment_url VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Users(user_id)
);

CREATE TABLE AuditLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    action VARCHAR(255) NOT NULL,
    actor_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id),
    FOREIGN KEY (actor_id) REFERENCES Users(user_id)
);

-- 3. Insert Sample Data
INSERT INTO Users (name, email, role, password_hash) VALUES
('Alice Johnson', 'alice@example.com', 'customer', 'hash1'),
('Bob Smith', 'bob@example.com', 'staff', 'hash2'),
('Charlie Brown', 'charlie@example.com', 'manager', 'hash3');

INSERT INTO Complaints (customer_id, category, description, status, attachment_url) VALUES
(1, 'Billing', 'Incorrect charge on my account', 'Open', NULL),
(1, 'Service', 'Internet service outage', 'In Progress', NULL);

INSERT INTO AuditLogs (complaint_id, action, actor_id) VALUES
(1, 'Complaint created', 1),
(2, 'Complaint created', 1),
(2, 'Status changed from Open to In Progress', 2);

-- 4. Create Views
CREATE VIEW v_open_complaints AS
SELECT c.complaint_id, u.name AS customer_name, c.category, c.status, c.created_at
FROM Complaints c
JOIN Users u ON c.customer_id = u.user_id
WHERE c.status = 'Open';

CREATE VIEW v_complaints_with_audit AS
SELECT c.complaint_id, c.category, c.status, a.action, a.timestamp, u.name AS actor_name
FROM Complaints c
JOIN AuditLogs a ON c.complaint_id = a.complaint_id
LEFT JOIN Users u ON a.actor_id = u.user_id;

-- 5. Stored Procedures
DELIMITER $$

CREATE PROCEDURE sp_create_complaint(
    IN p_customer_id INT,
    IN p_category VARCHAR(100),
    IN p_description TEXT,
    IN p_attachment_url VARCHAR(255)
)
BEGIN
    INSERT INTO Complaints (customer_id, category, description, attachment_url)
    VALUES (p_customer_id, p_category, p_description, p_attachment_url);

    INSERT INTO AuditLogs (complaint_id, action, actor_id)
    VALUES (LAST_INSERT_ID(), 'Complaint created', p_customer_id);
END$$

CREATE PROCEDURE sp_update_complaint_status(
    IN p_complaint_id INT,
    IN p_new_status ENUM('Open','In Progress','Resolved','Closed'),
    IN p_actor_id INT
)
BEGIN
    DECLARE v_old_status ENUM('Open','In Progress','Resolved','Closed');

    SELECT status INTO v_old_status
    FROM Complaints
    WHERE complaint_id = p_complaint_id;

    UPDATE Complaints
    SET status = p_new_status
    WHERE complaint_id = p_complaint_id;

    INSERT INTO AuditLogs (complaint_id, action, actor_id)
    VALUES (p_complaint_id,
            CONCAT('Status changed from ', v_old_status, ' to ', p_new_status),
            p_actor_id);
END$$

DELIMITER ;

-- 6. Triggers
DELIMITER $$

CREATE TRIGGER trg_complaint_insert
AFTER INSERT ON Complaints
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (complaint_id, action, actor_id)
    VALUES (NEW.complaint_id, 'Complaint created', NEW.customer_id);
END$$

CREATE TRIGGER trg_complaint_update
AFTER UPDATE ON Complaints
FOR EACH ROW
BEGIN
    DECLARE v_action VARCHAR(100);

    IF NEW.status <> OLD.status THEN
        SET v_action = CONCAT('Status changed from ', OLD.status, ' to ', NEW.status);
    ELSE
        SET v_action = 'Complaint updated';
    END IF;

    INSERT INTO AuditLogs (complaint_id, action, actor_id)
    VALUES (NEW.complaint_id, v_action, NULL);
END$$

CREATE TRIGGER trg_complaint_delete
AFTER DELETE ON Complaints
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (complaint_id, action, actor_id)
    VALUES (OLD.complaint_id, 'Complaint deleted', NULL);
END$$

DELIMITER ;

-- 7. Test Queries (Sample Outputs)

-- List all complaints
SELECT * FROM Complaints;

-- List all users
SELECT * FROM Users;

-- List open complaints using view
SELECT * FROM v_open_complaints;

-- List complaints with audit logs
SELECT * FROM v_complaints_with_audit ORDER BY complaint_id, timestamp;

-- Call stored procedure: Add a complaint
CALL sp_create_complaint(1, 'Shipping', 'Package damaged upon arrival', NULL);

-- Check complaints after insert
SELECT * FROM Complaints ORDER BY complaint_id DESC LIMIT 3;

-- Call stored procedure: Update complaint status
CALL sp_update_complaint_status(3, 'In Progress', 2);

-- Check audit logs after status update
SELECT * FROM AuditLogs WHERE complaint_id = 3 ORDER BY timestamp DESC;
