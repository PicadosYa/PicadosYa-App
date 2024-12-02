ALTER TABLE fields 
ADD COLUMN status BOOLEAN NULL DEFAULT TRUE;

ALTER TABLE fields ADD COLUMN user_id INT NULL AFTER id;
ALTER TABLE fields ADD CONSTRAINT fk_fields_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

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
