DROP PROCEDURE InsertReservation;

CREATE PROCEDURE InsertReservation(
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME,
    IN p_status ENUM('reserved', 'canceled', 'completed')
)
BEGIN
    INSERT INTO reservations (field_id, user_id, date, start_time, end_time, status)
    VALUES (p_field_id, p_user_id, p_date, p_start_time, p_end_time, p_status);
END

