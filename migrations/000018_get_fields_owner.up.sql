CREATE PROCEDURE GetFieldsByOwnerId (
    IN p_user_id INT
)
BEGIN
    SELECT 
        f.name AS field_name, 
        f.address AS field_address, 
        f.type AS field_type, 
        f.phone AS field_phone, 
        f.status AS field_status
    FROM 
        fields f
    WHERE 
        f.user_id = p_user_id;
END;