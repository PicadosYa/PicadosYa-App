CREATE PROCEDURE `GetFieldReservationsByMonthAndId`(
    IN p_field_id INT,
    IN p_month VARCHAR(7) -- formato 'YYYY-MM'
)
BEGIN
    SELECT 
        f.id,
        f.name,
        f.address,
        COALESCE (f.neighborhood, ""),
        COALESCE (f.phone, ""),
        f.latitude,
        f.longitude,
        COALESCE (f.type, "5"),
        f.price,
        COALESCE (f.description, ""),
        COALESCE (f.logo_url, ""),
        f.average_rating,
        f.creation_date,
        f.available_days,
        COALESCE (GROUP_CONCAT(DISTINCT fp.photo_url), "") AS photos,
        COALESCE (GROUP_CONCAT(DISTINCT s.name), "") AS services,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT(fa.start_time, '-', fa.end_time)), "") AS unavailable_dates,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT('{date: ', r.date, ', start_time: ', r.start_time, ', end_time: ', r.end_time, '}')), "") AS reservations
    FROM 
        fields f
    LEFT JOIN 
        field_photos fp ON f.id = fp.field_id
    LEFT JOIN 
        services_fields sf ON f.id = sf.id_field
    LEFT JOIN 
        services s ON sf.id_service = s.id
    LEFT JOIN 
        field_availability fa ON f.id = fa.field_id 
        AND fa.end_time >= CONCAT(p_month, '-01')
    LEFT JOIN
        reservations r ON f.id = r.field_id
        AND r.date >= CONCAT(p_month, '-01')  -- Reservas desde el primer día del mes especificado en adelante
    WHERE 
        f.id = p_field_id
    GROUP BY 
        f.id, f.name, f.address, f.neighborhood, f.phone, f.type, f.price, f.description, f.logo_url, f.creation_date;
END