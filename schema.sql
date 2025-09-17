-- Create database & user (idempotent-ish)
CREATE DATABASE IF NOT EXISTS demodb CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'demo'@'%' IDENTIFIED BY 'demopw';
GRANT ALL PRIVILEGES ON demodb.* TO 'demo'@'%';
FLUSH PRIVILEGES;

-- App table
USE demo;
CREATE TABLE IF NOT EXISTS students (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    favorite_color VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

-- Seed data
INSERT INTO students (name, favorite_color) VALUES
    ('Ada Lovelace', 'Teal'),
    ('Alan Turing', 'Indigo'),
    ('Grace Hopper', 'Crimson')
ON DUPLICATE KEY UPDATE name=VALUES(name), favorite_color=VALUES(favorite_color);