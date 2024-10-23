-- ====================================================
-- Create main database if it does not exist
-- ====================================================
CREATE DATABASE IF NOT EXISTS app_picadosYa;

-- Use the created database
USE app_picadosYa;

-- ====================================================
-- Users Table
-- Stores information about clients, field owners, and administrators
-- ====================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Hashed password
    phone VARCHAR(20),
    profile_picture_url VARCHAR(255), -- URL to profile picture
    role ENUM('client', 'field', 'admin') NOT NULL, -- User role, 'field' refers to field login
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user
INSERT IGNORE INTO users (first_name, last_name, email, password, role) 
VALUES ('Admin', 'Admin', 'admin@picadosya.com', 'hashed_password', 'admin');

-- ====================================================
-- Fields Table
-- Stores information about the fields registered
-- ====================================================
CREATE TABLE IF NOT EXISTS fields (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    neighborhood VARCHAR(100),
    phone VARCHAR(20),
    latitude DECIMAL(10, 8), -- Latitude coordinate for geolocation
    longitude DECIMAL(11, 8), -- Longitude coordinate for geolocation
    type ENUM('5', '7', '11') NOT NULL, -- Field type based on the number of players
    price DECIMAL(10, 2) NOT NULL, -- Price per reservation
    description TEXT,
    logo_url VARCHAR(255), -- URL to the field logo
    average_rating DECIMAL(3, 2) DEFAULT 0, -- Average user ratings
    services TEXT, -- Additional services offered by the field
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indices to improve search by location and type
CREATE INDEX idx_fields_location ON fields (latitude, longitude);
CREATE INDEX idx_fields_type ON fields (type);

-- ====================================================
-- Field Photos Table
-- Stores URLs of photos associated with each field
-- ====================================================
CREATE TABLE IF NOT EXISTS field_photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE
);

-- ====================================================
-- Field Availability Table
-- Stores the schedules when a field is available
-- ====================================================
CREATE TABLE IF NOT EXISTS field_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT NOT NULL,
    day_of_week ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE
);

-- Index to improve search by field and day of the week
CREATE INDEX idx_availability_field_day ON field_availability (field_id, day_of_week);

-- ====================================================
-- Reservations Table
-- Stores reservations made by clients
-- ====================================================
CREATE TABLE IF NOT EXISTS reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT NOT NULL,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('reserved', 'canceled', 'completed') DEFAULT 'reserved',
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index to prevent duplicate reservations for the same field and time slot
CREATE UNIQUE INDEX idx_unique_reservations ON reservations (field_id, date, start_time, end_time);

-- ====================================================
-- Payments Table
-- Stores information about payments made by clients
-- ====================================================
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('mercadopago') NOT NULL,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mercadopago_id VARCHAR(255), -- MercadoPago transaction ID
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index for quick search by payment status
CREATE INDEX idx_payments_status ON payments (status);

-- ====================================================
-- Field Ratings and Comments Table
-- Stores ratings and comments made by clients about fields
-- ====================================================
CREATE TABLE IF NOT EXISTS field_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- Rating from 1 to 5
    comment TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index to improve search for ratings by field
CREATE INDEX idx_ratings_field ON field_ratings (field_id);

-- ====================================================
-- Sessions Table
-- Manages user sessions (optional)
-- ====================================================
CREATE TABLE IF NOT EXISTS sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ====================================================
-- Notifications Table
-- Stores notifications sent to users
-- ====================================================
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('reservation_confirmed', 'reservation_canceled', 'other') NOT NULL,
    message TEXT NOT NULL,
    sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index to improve search for notifications by user
CREATE INDEX idx_notifications_user ON notifications (user_id, read);

-- ====================================================
-- Export Logs Table
-- Logs export actions performed by field owners
-- ====================================================
CREATE TABLE IF NOT EXISTS export_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    export_type ENUM('csv', 'other') NOT NULL,
    export_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ====================================================
-- Sales Statistics Table
-- Stores data for generating sales reports and charts
-- ====================================================
CREATE TABLE IF NOT EXISTS sales_statistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL,
    total_reservations INT DEFAULT 0,
    income DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index to improve search for statistics by owner, year, and month
CREATE INDEX idx_statistics_owner_date ON sales_statistics (owner_id, year, month);
