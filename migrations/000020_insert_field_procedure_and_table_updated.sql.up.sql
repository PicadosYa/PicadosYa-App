-- Modify fields table to add user_id
DROP PROCEDURE IF EXISTS `InsertField`;

-- Updated InsertField procedure
CREATE PROCEDURE `InsertField`(
    IN p_user_id INT,
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
    -- Insertar en la tabla 'fields' incluyendo user_id
    INSERT INTO fields (
        user_id, name, address, neighborhood, phone, 
        latitude, longitude, type, price, description, 
        logo_url, creation_date, available_days
    )
    VALUES (
        p_user_id, p_name, p_address, p_neighborhood, p_phone, 
        p_latitude, p_longitude, p_type, p_price, p_description, 
        p_logo_url, p_creation_date, p_available_days
    );
    
    -- Obtener el último id insertado (el id del campo)
    SET @field_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla 'field_photos'
    -- Separar las fotos por comas y agregarlas
    WHILE LOCATE(',', p_photos) > 0 DO
        SET @photo_url = SUBSTRING_INDEX(p_photos, ',', 1);
        INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, @photo_url);
        SET p_photos = SUBSTRING(p_photos, LOCATE(',', p_photos) + 1);
    END WHILE;
    
    -- Insertar última foto si existe
    IF p_photos != '' THEN
        INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, p_photos);
    END IF;
    
    -- Insertar en la tabla 'services_fields' (asociar los IDs de servicios existentes)
    IF p_service_ids != '' THEN
        -- Separar los IDs de servicios por comas y agregarlos
        WHILE LOCATE(',', p_service_ids) > 0 DO
            SET @service_id = SUBSTRING_INDEX(p_service_ids, ',', 1);
            INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, @service_id);
            SET p_service_ids = SUBSTRING(p_service_ids, LOCATE(',', p_service_ids) + 1);
        END WHILE;
        
        -- Insertar el último ID de servicio
        INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, p_service_ids);
    END IF;
END;