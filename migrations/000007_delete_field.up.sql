CREATE PROCEDURE `DeleteField`(
    IN p_field_id INT
)
BEGIN
    -- Eliminar las fotos asociadas al field_id
    DELETE FROM field_photos WHERE field_id = p_field_id;

    -- Eliminar las asociaciones de servicios para el field_id
    DELETE FROM services_fields WHERE id_field = p_field_id;

    -- Finalmente, eliminar el registro en la tabla 'fields'
    DELETE FROM fields WHERE id = p_field_id;
END