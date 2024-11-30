CREATE PROCEDURE GetReservationsByOwner (
    IN OwnerID INT
)
BEGIN
    SELECT 
        r.id AS id_reserv,
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

DROP PROCEDURE IF EXISTS GET_USER_FAVORITE_FIELDS;
CREATE PROCEDURE GET_USER_FAVORITE_FIELDS (
    IN USER_ID INT
)
BEGIN
    SELECT 
        F.NAME AS FIELD_NAME, 
        MAX(F.ADDRESS) AS ADDRESS, 
        MAX(F.PHONE) AS FIELD_PHONE, 
        MAX(fp.photo_url) AS LOGO_URL
    FROM 
        user_favorite_fields UFF
    INNER JOIN 
        fields F ON F.ID = UFF.FIELD_ID
    INNER JOIN 
        users U ON U.ID = UFF.USER_ID
    LEFT JOIN 
        field_photos fp ON fp.field_id = F.id
    WHERE 
        U.ID = USER_ID
    GROUP BY 
        F.NAME;
END;
