DELIMITER $$

-- Eliminar procedimientos en orden inverso al de creación
DROP PROCEDURE IF EXISTS GET_USER_FAVORITE_FIELDS$$
DROP PROCEDURE IF EXISTS GetUsersByFavoriteField$$
DROP PROCEDURE IF EXISTS GetFavoriteFieldsByUser$$

DELIMITER ;

-- Eliminar la tabla `user_favorite_fields`
DROP TABLE IF EXISTS `user_favorite_fields`;
