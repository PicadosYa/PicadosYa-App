CREATE PROCEDURE `PatchField`(
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
    -- Actualizar los campos no vacíos en la tabla 'fields'
    UPDATE fields
    SET 
        name = COALESCE(NULLIF(p_name, ''), name),
        address = COALESCE(NULLIF(p_address, ''), address),
        neighborhood = COALESCE(NULLIF(p_neighborhood, ''), neighborhood),
        phone = COALESCE(NULLIF(p_phone, ''), phone),
        latitude = COALESCE(NULLIF(p_latitude, 0), latitude),
        longitude = COALESCE(NULLIF(p_longitude, 0), longitude),
        type = COALESCE(NULLIF(p_type, ''), type),
        price = COALESCE(NULLIF(p_price, 0), price),
        description = COALESCE(NULLIF(p_description, ''), description),
        logo_url = COALESCE(NULLIF(p_logo_url, ''), logo_url),
        creation_date = COALESCE(NULLIF(p_creation_date, '0001-01-01'), creation_date),
        available_days = COALESCE(NULLIF(p_available_days, ''), available_days)
    WHERE id = p_field_id;

    -- Actualizar las fotos solo si p_photos no está vacío
    IF p_photos IS NOT NULL AND p_photos != '' THEN
        DELETE FROM field_photos WHERE field_id = p_field_id;

        -- Insertar nuevas fotos en la tabla 'field_photos'
        WHILE LOCATE(',', p_photos) > 0 DO
            SET @photo_url = SUBSTRING_INDEX(p_photos, ',', 1);
            INSERT INTO field_photos (field_id, photo_url) VALUES (p_field_id, @photo_url);
            SET p_photos = SUBSTRING(p_photos, LOCATE(',', p_photos) + 1);
        END WHILE;
        INSERT INTO field_photos (field_id, photo_url) VALUES (p_field_id, p_photos); -- Última foto
    END IF;

    -- Actualizar los servicios solo si p_service_ids no está vacío
    IF p_service_ids IS NOT NULL AND p_service_ids != '' THEN
        DELETE FROM services_fields WHERE id_field = p_field_id;

        -- Insertar nuevas asociaciones en la tabla 'services_fields'
        WHILE LOCATE(',', p_service_ids) > 0 DO
            SET @service_id = SUBSTRING_INDEX(p_service_ids, ',', 1);
            INSERT INTO services_fields (id_field, id_service) VALUES (p_field_id, @service_id);
            SET p_service_ids = SUBSTRING(p_service_ids, LOCATE(',', p_service_ids) + 1);
        END WHILE;
        INSERT INTO services_fields (id_field, id_service) VALUES (p_field_id, p_service_ids); -- Último servicio
    END IF;
END