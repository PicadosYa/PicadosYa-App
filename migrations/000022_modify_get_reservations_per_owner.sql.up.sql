DROP PROCEDURE IF EXISTS GetReservationsPerOwnerByMonth;

CREATE PROCEDURE GetReservationsPerOwnerByMonth(
    IN OwnerID INT,
    IN MonthsAgo INT
)
BEGIN
    SELECT 
	s.id as user_id,
	s.email as user_email,
        s.first_name AS user_first_name, 
	s.last_name AS user_last_name,
	COALESCE (s.profile_picture_url, "") as user_profile,
	f.id as field_id,
        f.name AS field_name,
	f.address as field_address,
	f.price as field_price,
        f.phone AS phone,
        f.type AS type,
        r.date AS date,
        r.start_time AS start_time,
        r.end_time AS end_time,
        r.status
    FROM 
        reservations r
    INNER JOIN 
        fields f ON f.id = r.field_id
    INNER JOIN 
        users s ON r.user_id = s.id
    WHERE 
        f.user_id = OwnerID
        AND r.date >= DATE_SUB(CURDATE(), INTERVAL MonthsAgo MONTH)
    ORDER BY 
        r.id ASC;
END;