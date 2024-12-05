CREATE TRIGGER after_insert_fields_update_user_role
AFTER INSERT ON fields
FOR EACH ROW
BEGIN
    DECLARE current_user_role VARCHAR(50);

    -- Obtener el rol actual del usuario
    SELECT role INTO current_user_role 
    FROM users 
    WHERE id = NEW.user_id;

    -- Verificar y actualizar el rol si es necesario
    IF current_user_role != 'field' THEN
        UPDATE users 
        SET role = 'field' 
        WHERE id = NEW.user_id;
    END IF;
END;