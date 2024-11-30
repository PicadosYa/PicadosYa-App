-- Drop the updated procedures
DROP PROCEDURE IF EXISTS `InsertReservation`;
DROP PROCEDURE IF EXISTS `GetReservationsByUserId`;

-- Restore the original InsertReservation procedure
CREATE PROCEDURE `InsertReservation`(
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME
)
BEGIN
    INSERT INTO reservations (field_id, user_id, date, start_time, end_time)
    VALUES (p_field_id, p_user_id, p_date, p_start_time, p_end_time);
END;

-- Restore the original GetReservationsByUserId procedure
CREATE PROCEDURE GetReservationsByUserId(IN userId INT)
BEGIN
    SELECT
        u.email AS user_email,
        r.date AS reservation_date,
        r.start_time,
        r.end_time,    
        f.name AS field_name,
        r.status AS status_reservation
    FROM
        reservations r
    INNER JOIN
        users u ON r.user_id = u.id
    INNER JOIN
        fields f ON r.field_id = f.id
    WHERE
        u.id = userId;
END;

-- Remove the payment_id column from the reservations table
ALTER TABLE reservations 
DROP COLUMN payment_id;
