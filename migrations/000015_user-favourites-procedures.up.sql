CREATE TABLE `user_favorite_fields` (
  `user_id` int NOT NULL,
  `field_id` int NOT NULL,
  `marked_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `field_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE
);

DELIMITER $$

CREATE PROCEDURE GetFavoriteFieldsByUser(
    IN userId INT
)
BEGIN
    SELECT uff.user_id as user_id, f.name as field_name, f.address as field_address, f.logo_url as logo_url
    FROM `fields` f
    JOIN `user_favorite_fields` uff ON f.id = uff.field_id
    WHERE uff.user_id = userId;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetUsersByFavoriteField(
    IN fieldId INT
)
BEGIN
    SELECT u.first_name, u.email
    FROM `users` u
    JOIN `user_favorite_fields` uff ON u.id = uff.user_id
    WHERE uff.field_id = fieldId;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE GET_USER_FAVORITE_FIELDS(
    IN USER_ID INT
)
BEGIN
    SELECT 
        F.NAME AS FIELD_NAME, 
        F.ADDRESS AS ADDRESS, 
        F.PHONE AS FIELD_PHONE, 
        F.LOGO_URL AS LOGO_URL
    FROM 
        user_favorite_fields UFF
    INNER JOIN 
        fields F ON F.ID = UFF.FIELD_ID
    INNER JOIN 
        users U ON U.ID = UFF.USER_ID
    WHERE 
        U.ID = USER_ID;
END$$

DELIMITER ;