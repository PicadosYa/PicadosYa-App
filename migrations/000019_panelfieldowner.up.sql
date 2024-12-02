CREATE PROCEDURE GetReservationsPerOwnerByMonth(
    IN OwnerID INT,
    IN MonthsAgo INT
)
BEGIN
    SELECT 
        CONCAT(s.first_name, " ", s.last_name) AS user_name,
        f.name AS field_name,
        r.date AS date,
        r.start_time AS start_time,
        r.end_time AS end_time,
        f.type AS type,
        f.phone AS phone,
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


CREATE PROCEDURE GetReservationsPerOwnerByHour(
    IN OwnerID INT,
    IN HourIn INT
)
BEGIN
    SELECT 
        CONCAT(s.first_name, " ", s.last_name) AS user_name,
        f.name AS field_name,
        r.date AS date,
        r.start_time AS start_time,
        r.end_time AS end_time,
        f.type AS type,
        f.phone AS phone,
        r.status
    FROM 
        reservations r
    INNER JOIN 
        fields f ON f.id = r.field_id
    INNER JOIN 
        users s ON r.user_id = s.id
    WHERE 
        f.user_id = OwnerID
        AND HOUR(r.start_time) = HourIn
    ORDER BY 
        r.id ASC;
END;

DROP procedure GetReservationsByOwner;
CREATE PROCEDURE `GetReservationsByOwner`(
    IN OwnerID INT
)
BEGIN
    SELECT 
        CONCAT(s.first_name, " ", s.last_name) AS user_name,
        f.name AS field_name,
        r.date AS date,
        r.start_time AS start_time,
        r.end_time AS end_time,
        f.type AS type,
        f.phone AS phone,
        r.status
    FROM 
        reservations r
    INNER JOIN 
        fields f ON f.id = r.field_id
    INNER JOIN 
        users s ON r.user_id = s.id
    WHERE 
        f.user_id = OwnerID
    ORDER BY 
        r.id ASC;
	END;
    