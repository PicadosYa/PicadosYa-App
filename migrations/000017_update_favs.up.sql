-- Cambioss nuevos
-- ALTER TABLE `fields` ADD COLUMN `user_id` INT NULL AFTER `id`;
-- ALTER TABLE `fields` ADD CONSTRAINT `fk_fields_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
END //


-- DROP PROCEDURE InsertField;

-- CREATE PROCEDURE `InsertField`(
--     IN p_user_id INT,            -- ID del propietario
--     IN p_name VARCHAR(255),
--     IN p_address VARCHAR(255),
--     IN p_neighborhood VARCHAR(255),
--     IN p_phone VARCHAR(50),
 --    IN p_latitude DECIMAL(10, 8),
--     IN p_longitude DECIMAL(11, 8),
 --    IN p_type VARCHAR(50),
--     IN p_price DECIMAL(10, 2),
 --    IN p_description TEXT,
--     IN p_logo_url VARCHAR(255),
--     IN p_creation_date DATE,
 --    IN p_available_days VARCHAR(14),
 --    IN p_photos TEXT,            -- Coma separada de URLs de fotos
 --    IN p_service_ids TEXT        -- Coma separada de IDs de servicios
-- )
-- BEGIN
    -- Insertar en la tabla 'fields'
--     INSERT INTO fields (user_id, name, address, neighborhood, phone, latitude, longitude, type, price, description, logo_url, creation_date, available_days)
--     VALUES (p_user_id, p_name, p_address, p_neighborhood, p_phone, p_latitude, p_longitude, p_type, p_price, p_description, p_logo_url, p_creation_date, p_available_days);
    
    -- Obtener el último id insertado (el id del campo)
--     SET @field_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla 'field_photos'
    -- Separar las fotos por comas y agregarlas
 --    WHILE LOCATE(',', p_photos) > 0 DO
 --        SET @photo_url = SUBSTRING_INDEX(p_photos, ',', 1);
 --        INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, @photo_url);
 --        SET p_photos = SUBSTRING(p_photos, LOCATE(',', p_photos) + 1);
 --    END WHILE;
 --    INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, p_photos); -- Última foto
    
    -- Insertar en la tabla 'services_fields' (asociar los IDs de servicios existentes)
    -- Separar los IDs de servicios por comas y agregarlos
 --    WHILE LOCATE(',', p_service_ids) > 0 DO
  --       SET @service_id = SUBSTRING_INDEX(p_service_ids, ',', 1);
  --       INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, @service_id);
  --       SET p_service_ids = SUBSTRING(p_service_ids, LOCATE(',', p_service_ids) + 1);
 --    END WHILE;
    -- Insertar el último ID de servicio
 --    INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, p_service_ids);
    
-- END $$


CREATE PROCEDURE GetFieldPhotoByName(IN fieldName VARCHAR(100))
BEGIN
    SELECT fp.photo_url as photo_url
    FROM fields f
    INNER JOIN field_photos fp ON f.id = fp.field_id
    WHERE f.name = fieldName
    LIMIT 1;
END 

drop procedure GET_USER_FAVORITE_FIELDS;
CREATE PROCEDURE GET_USER_FAVORITE_FIELDS(
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
