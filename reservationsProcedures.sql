DELIMITER //

CREATE PROCEDURE InsertReservation(
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME,
    IN p_created_at DATETIME
)
BEGIN
INSERT INTO reservations (field_id, user_id, start_time, end_time, created_at)
VALUES (p_field_id, p_user_id, p_start_time, p_end_time, p_created_at);
END //

CREATE PROCEDURE GetReservationById(
    IN p_id INT
)
BEGIN
SELECT * FROM reservations WHERE id = p_id;
END //

CREATE PROCEDURE GetReservationsWithLimitOffset(
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
SELECT * FROM reservations LIMIT p_limit OFFSET p_offset;
END //

CREATE PROCEDURE UpdateReservation(
    IN p_id INT,
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME
)
BEGIN
UPDATE reservations
SET field_id = p_field_id, user_id = p_user_id, start_time = p_start_time, end_time = p_end_time
WHERE id = p_id;
END //

CREATE PROCEDURE DeleteReservation(
    IN p_id INT
)
BEGIN
DELETE FROM reservations WHERE id = p_id;
END //

DELIMITER ;