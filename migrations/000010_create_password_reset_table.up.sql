CREATE TABLE password_recovery_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE `users`
MODIFY `position_player` varchar(100) DEFAULT NULL;

ALTER TABLE `users`
MODIFY `phone` varchar(100) NOT NULL;

ALTER TABLE `users`
MODIFY `age` int DEFAULT NULL;