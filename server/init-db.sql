-- Initialize projectdb database with dummy data
-- This script runs automatically when MySQL container starts

-- Create database
CREATE DATABASE IF NOT EXISTS projectdb;
USE projectdb;

-- Create user and grant privileges
CREATE USER IF NOT EXISTS 'testuser'@'%' IDENTIFIED BY 'testpass';
GRANT ALL PRIVILEGES ON projectdb.* TO 'testuser'@'%';
FLUSH PRIVILEGES;

-- Authentication Service Tables
CREATE TABLE IF NOT EXISTS userdata (
  userid VARCHAR(36) PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role VARCHAR(20) DEFAULT 'USER',
  enabled BOOLEAN DEFAULT TRUE,
  locked BOOLEAN DEFAULT FALSE,
  accountreq BOOLEAN DEFAULT FALSE,
  createdate DATE,
  resetPasswordToken VARCHAR(255),
  emailVerified BOOLEAN DEFAULT FALSE,
  otp VARCHAR(10),
  user_image_name VARCHAR(255)
);

-- Customer Service Tables
CREATE TABLE IF NOT EXISTS userdetails (
  userdetailsid INT AUTO_INCREMENT PRIMARY KEY,
  userid VARCHAR(36) UNIQUE,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(100),
  mobile VARCHAR(20),
  pan VARCHAR(20),
  adhaar VARCHAR(20),
  dateofbirth DATE,
  gender CHAR(1),
  address VARCHAR(255),
  city VARCHAR(50),
  state VARCHAR(50),
  pin VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS beneficiaries (
  beneficiaryid INT AUTO_INCREMENT PRIMARY KEY,
  userid VARCHAR(36),
  beneficiaryname VARCHAR(100),
  beneaccountno BIGINT,
  relation VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Account Service Tables
CREATE TABLE IF NOT EXISTS bankaccount (
  accountno BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(36),
  accountType VARCHAR(50),
  dateCreated VARCHAR(10),
  timeCreated VARCHAR(8),
  balance DECIMAL(15,2) DEFAULT 0.00,
  isactive BOOLEAN DEFAULT TRUE,
  INDEX idx_userid (user_id)
);

CREATE TABLE IF NOT EXISTS transactions (
  transactionId INT AUTO_INCREMENT PRIMARY KEY,
  fromAccount BIGINT,
  toAccount BIGINT,
  senderBal DECIMAL(15,2),
  receiverBal DECIMAL(15,2),
  amount DECIMAL(15,2),
  transactionStatus VARCHAR(20),
  transactionDate VARCHAR(10),
  transactionTime VARCHAR(8),
  description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS loanaccount (
  loanaccountno BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(36),
  principalAmount DECIMAL(15,2),
  rateofinterest DECIMAL(5,2),
  duration INT,
  approvaldate VARCHAR(10),
  isapproved BOOLEAN DEFAULT FALSE
);

-- Notification Service Tables
CREATE TABLE IF NOT EXISTS mail (
  id INT AUTO_INCREMENT PRIMARY KEY,
  to_email VARCHAR(100),
  subject VARCHAR(255),
  body TEXT,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'PENDING'
);

-- Insert dummy test users
-- Password for all users: password123
-- BCrypt hash (10 rounds): $2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ/1a
-- This hash corresponds to the plaintext password "password123"
-- You can verify with: BCryptPasswordEncoder.matches("password123", hash)
INSERT INTO userdata (userid, firstname, lastname, email, password, role, enabled, locked, createdate, emailVerified) VALUES
('user-001', 'John', 'Doe', 'user1@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ/1a', 'USER', TRUE, FALSE, CURDATE(), TRUE),
('user-002', 'Jane', 'Smith', 'user2@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ/1a', 'USER', TRUE, FALSE, CURDATE(), TRUE),
('user-003', 'Bob', 'Johnson', 'user3@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ/1a', 'USER', TRUE, FALSE, CURDATE(), TRUE),
('admin-001', 'Admin', 'User', 'admin@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ/1a', 'ADMIN', TRUE, FALSE, CURDATE(), TRUE)
ON DUPLICATE KEY UPDATE email=email;

-- Insert dummy user details
INSERT INTO userdetails (userid, firstname, lastname, email, mobile, address, city, state, pin) VALUES
('user-001', 'John', 'Doe', 'user1@example.com', '1234567890', '123 Main St', 'New York', 'NY', '10001'),
('user-002', 'Jane', 'Smith', 'user2@example.com', '0987654321', '456 Oak Ave', 'Los Angeles', 'CA', '90001'),
('user-003', 'Bob', 'Johnson', 'user3@example.com', '5555555555', '789 Pine Rd', 'Chicago', 'IL', '60601')
ON DUPLICATE KEY UPDATE email=email;

-- Insert dummy bank accounts
INSERT INTO bankaccount (accountno, user_id, accountType, dateCreated, timeCreated, balance, isactive) VALUES
(1000001, 'user-001', 'Savings', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 10000.00, TRUE),
(1000002, 'user-001', 'Checking', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 5000.00, TRUE),
(1000003, 'user-002', 'Savings', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 15000.00, TRUE),
(1000004, 'user-002', 'Checking', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 7500.00, TRUE),
(1000005, 'user-003', 'Savings', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 20000.00, TRUE)
ON DUPLICATE KEY UPDATE balance=balance;

-- Insert dummy transactions
INSERT INTO transactions (fromAccount, toAccount, senderBal, receiverBal, amount, transactionStatus, transactionDate, transactionTime, description) VALUES
(1000001, 1000003, 9500.00, 15500.00, 500.00, 'SUCCESS', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 'Payment for services'),
(1000002, 1000004, 7000.00, 8000.00, 500.00, 'SUCCESS', DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%H:%i:%s'), 'Fund transfer'),
(1000003, 1000001, 15000.00, 10000.00, 500.00, 'SUCCESS', DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY), '%Y-%m-%d'), '10:30:00', 'Refund')
ON DUPLICATE KEY UPDATE transactionId=transactionId;

-- Insert dummy beneficiaries
INSERT INTO beneficiaries (userid, beneficiaryname, beneaccountno, relation) VALUES
('user-001', 'Jane Smith', 1000003, 'Friend'),
('user-002', 'John Doe', 1000001, 'Colleague'),
('user-003', 'Jane Smith', 1000003, 'Family')
ON DUPLICATE KEY UPDATE beneficiaryid=beneficiaryid;

