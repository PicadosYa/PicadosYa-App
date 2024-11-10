CREATE PROCEDURE `UpdateField`(
    IN p_field_id INT,
    IN p_name VARCHAR(255),
    IN p_address VARCHAR(255),
    IN p_neighborhood VARCHAR(255),
    IN p_phone VARCHAR(50),
    IN p_latitude DECIMAL(10, 8),
    IN p_longitude DECIMAL(11, 8),
    IN p_type VARCHAR(50),
    IN p_price DECIMAL(10, 2),
    IN p_description TEXT,
    IN p_logo_url VARCHAR(255),
    IN p_creation_date DATE,
    IN p_available_days VARCHAR(14),
    IN p_photos TEXT,         -- Coma separada de URLs de fotos
    IN p_service_ids TEXT     -- Coma separada de IDs de servicios
)
BEGIN
    -- Actualizar en la tabla 'fields' usando el field_id
    UPDATE fields
    SET 
        name = p_name,
        address = p_address,
        neighborhood = p_neighborhood,
        phone = p_phone,
        latitude = p_latitude,
        longitude = p_longitude,
        type = p_type,
        price = p_price,
        description = p_description,
        logo_url = p_logo_url,
        creation_date = p_creation_date,
        available_days = p_available_days
    WHERE id = p_field_id;

    -- Limpiar las entradas existentes en 'field_photos' para el field_id dado
    DELETE FROM field_photos WHERE field_id = p_field_id;

    -- Insertar nuevas fotos en la tabla 'field_photos'
    WHILE LOCATE(',', p_photos) > 0 DO
        SET @photo_url = SUBSTRING_INDEX(p_photos, ',', 1);
        INSERT INTO field_photos (field_id, photo_url) VALUES (p_field_id, @photo_url);
        SET p_photos = SUBSTRING(p_photos, LOCATE(',', p_photos) + 1);
    END WHILE;
    INSERT INTO field_photos (field_id, photo_url) VALUES (p_field_id, p_photos); -- Última foto

    -- Limpiar las entradas existentes en 'services_fields' para el field_id dado
    DELETE FROM services_fields WHERE id_field = p_field_id;

    -- Insertar nuevas asociaciones en la tabla 'services_fields' para el id_field dado
    WHILE LOCATE(',', p_service_ids) > 0 DO
        SET @service_id = SUBSTRING_INDEX(p_service_ids, ',', 1);
        INSERT INTO services_fields (id_field, id_service) VALUES (p_field_id, @service_id);
        SET p_service_ids = SUBSTRING(p_service_ids, LOCATE(',', p_service_ids) + 1);
    END WHILE;
    INSERT INTO services_fields (id_field, id_service) VALUES (p_field_id, p_service_ids); -- Último servicio
    
END 