-- Alter table to add payment_id column
ALTER TABLE reservations 
ADD COLUMN payment_id INT NULL;

-- Drop existing procedures
DROP PROCEDURE IF EXISTS `InsertReservation`;
DROP PROCEDURE IF EXISTS `GetReservationsByUserId`;

-- New procedure for InsertReservation with payment_id
CREATE PROCEDURE `InsertReservation`(
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME,
    IN p_payment_id INT
)
BEGIN
    INSERT INTO reservations (field_id, user_id, date, start_time, end_time, payment_id)
    VALUES (p_field_id, p_user_id, p_date, p_start_time, p_end_time, p_payment_id);
    
    -- Return the ID of the newly inserted reservation
    SELECT LAST_INSERT_ID() AS new_reservation_id;
END;

-- Updated procedure to get reservations by user ID
CREATE PROCEDURE GetReservationsByUserId(IN userId INT)
BEGIN
    SELECT
        u.email AS user_email,
        r.date AS reservation_date,
        r.start_time,
        r.end_time,
        f.name AS field_name,
        r.status AS status_reservation,
        r.payment_id
    FROM
        reservations r
    INNER JOIN
        users u ON r.user_id = u.id
    INNER JOIN
        fields f ON r.field_id = f.id
    WHERE
        u.id = userId;
END;
