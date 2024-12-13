-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema picadosya
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema picadosya
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `picadosya` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `picadosya` ;

-- -----------------------------------------------------
-- Table `picadosya`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(100) NOT NULL,
  `profile_picture_url` VARCHAR(255) NULL DEFAULT NULL,
  `role` ENUM('client', 'field', 'admin') NOT NULL,
  `position_player` VARCHAR(100) NULL DEFAULT NULL,
  `registration_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `age` INT NULL DEFAULT NULL,
  `isVerified` TINYINT(1) NOT NULL DEFAULT '0',
  `accepted_terms` TINYINT(1) NOT NULL DEFAULT '0',
  `team_name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 1003
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`export_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`export_logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner_id` INT NOT NULL,
  `export_type` ENUM('csv', 'other') NOT NULL,
  `export_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `owner_id` (`owner_id` ASC) VISIBLE,
  CONSTRAINT `export_logs_ibfk_1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`fields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`fields` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL DEFAULT NULL,
  `name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `neighborhood` VARCHAR(100) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `latitude` DECIMAL(10,8) NULL DEFAULT NULL,
  `longitude` DECIMAL(11,8) NULL DEFAULT NULL,
  `type` ENUM('5', '7', '11') NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `logo_url` VARCHAR(255) NULL DEFAULT NULL,
  `average_rating` DECIMAL(3,2) NULL DEFAULT '0.00',
  `creation_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `available_days` VARCHAR(14) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci' NULL DEFAULT '1,2,3,4,5,6,7',
  `status` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  INDEX `idx_fields_location` (`latitude` ASC, `longitude` ASC) VISIBLE,
  INDEX `idx_fields_type` (`type` ASC) VISIBLE,
  INDEX `fk_fields_user` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_fields_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 85
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`field_availability`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`field_availability` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `field_id` INT NOT NULL,
  `day_of_week` ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') NOT NULL,
  `start_time` TIMESTAMP NOT NULL,
  `end_time` TIMESTAMP NOT NULL,
  `available` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  INDEX `idx_availability_field_day` (`field_id` ASC, `day_of_week` ASC) VISIBLE,
  CONSTRAINT `field_availability_ibfk_1`
    FOREIGN KEY (`field_id`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`field_photos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`field_photos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `field_id` INT NOT NULL,
  `photo_url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `field_id` (`field_id` ASC) VISIBLE,
  CONSTRAINT `field_photos_ibfk_1`
    FOREIGN KEY (`field_id`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 508
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`field_ratings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`field_ratings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `field_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `rating` INT NOT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `rating_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `idx_ratings_field` (`field_id` ASC) VISIBLE,
  CONSTRAINT `field_ratings_ibfk_1`
    FOREIGN KEY (`field_id`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `field_ratings_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`notifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`notifications` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `type` ENUM('reservation_confirmed', 'reservation_canceled', 'other') NOT NULL,
  `message` TEXT NOT NULL,
  `sent_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `read_status` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `idx_notifications_user` (`user_id` ASC, `read_status` ASC) VISIBLE,
  CONSTRAINT `notifications_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`reservations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`reservations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `field_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `status` ENUM('reserved', 'canceled', 'completed') NULL DEFAULT 'reserved',
  `reservation_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idx_unique_reservations` (`field_id` ASC, `date` ASC, `start_time` ASC, `end_time` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `reservations_ibfk_1`
    FOREIGN KEY (`field_id`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `reservations_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3003
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`payments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `reservation_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `payment_method` ENUM('mercadopago') NOT NULL,
  `status` ENUM('pending', 'completed', 'failed') NULL DEFAULT 'pending',
  `payment_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `mercadopago_id` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `reservation_id` (`reservation_id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `idx_payments_status` (`status` ASC) VISIBLE,
  CONSTRAINT `payments_ibfk_1`
    FOREIGN KEY (`reservation_id`)
    REFERENCES `picadosya`.`reservations` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `payments_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`sales_statistics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`sales_statistics` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner_id` INT NOT NULL,
  `month` INT NOT NULL,
  `year` INT NOT NULL,
  `total_reservations` INT NULL DEFAULT '0',
  `income` DECIMAL(10,2) NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  INDEX `idx_statistics_owner_date` (`owner_id` ASC, `year` ASC, `month` ASC) VISIBLE,
  CONSTRAINT `sales_statistics_ibfk_1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`schema_migrations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`schema_migrations` (
  `version` VARCHAR(255) NOT NULL,
  `dirty` TINYINT(1) NOT NULL,
  PRIMARY KEY (`version`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`services` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `icon` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`services_fields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`services_fields` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_field` INT NOT NULL,
  `id_service` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_field` (`id_field` ASC) VISIBLE,
  INDEX `id_service` (`id_service` ASC) VISIBLE,
  CONSTRAINT `services_fields_ibfk_1`
    FOREIGN KEY (`id_field`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `services_fields_ibfk_2`
    FOREIGN KEY (`id_service`)
    REFERENCES `picadosya`.`services` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 706
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`sessions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `creation_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `token` (`token` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `sessions_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`tokens_in_emails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`tokens_in_emails` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `expires_at` DATETIME NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `picadosya`.`user_favorite_fields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `picadosya`.`user_favorite_fields` (
  `user_id` INT NOT NULL,
  `field_id` INT NOT NULL,
  `marked_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `field_id`),
  INDEX `field_id` (`field_id` ASC) VISIBLE,
  CONSTRAINT `user_favorite_fields_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `picadosya`.`users` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `user_favorite_fields_ibfk_2`
    FOREIGN KEY (`field_id`)
    REFERENCES `picadosya`.`fields` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `picadosya` ;

-- -----------------------------------------------------
-- procedure DeleteField
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `DeleteField`(
    IN p_field_id INT
)
BEGIN
    -- Eliminar las fotos asociadas al field_id
    DELETE FROM field_photos WHERE field_id = p_field_id;

    -- Eliminar las asociaciones de servicios para el field_id
    DELETE FROM services_fields WHERE id_field = p_field_id;

    -- Finalmente, eliminar el registro en la tabla 'fields'
    DELETE FROM fields WHERE id = p_field_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DeleteReservation
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `DeleteReservation`(
    IN p_id INT
)
BEGIN
DELETE FROM reservations WHERE id = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GET_USER_FAVORITE_FIELDS
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GET_USER_FAVORITE_FIELDS`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetFavoriteFieldsByUser
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetFavoriteFieldsByUser`(
    IN userId INT
)
BEGIN
    SELECT uff.user_id as user_id, f.name as field_name, f.address as field_address, f.logo_url as logo_url
    FROM `fields` f
    JOIN `user_favorite_fields` uff ON f.id = uff.field_id
    WHERE uff.user_id = userId;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetFieldReservationsByMonthAndId
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetFieldReservationsByMonthAndId`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetFieldsByMonthWithLimitOffset
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetFieldsByMonthWithLimitOffset`(
    IN p_month VARCHAR(7), -- formato 'YYYY-MM'
    IN p_limit INT, -- Número de registros a devolver
    IN p_offset INT -- Registro desde donde empezar
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
        AND r.date >= CONCAT(p_month, '-01') -- Reservas a partir del mes especificado
    GROUP BY 
        f.id, f.name, f.address, f.neighborhood, f.phone, f.type, f.price, f.description, f.logo_url, f.creation_date
    LIMIT p_limit OFFSET p_offset;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetFieldsByOwnerId
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetFieldsByOwnerId`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationById
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationById`(
    IN p_id INT
)
BEGIN
SELECT * FROM reservations WHERE id = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsByOwner
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsByOwner`(
    IN OwnerID INT
)
BEGIN
    SELECT 
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
	END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsByUserId
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsByUserId`(IN userId INT)
BEGIN
    SELECT
        u.email AS user_email,
        r.date AS reservation_date,
        r.start_time,
        r.end_time,
        f.name AS field_name,
        r.status AS status_reservation,
        r.payment_id
    FROM
        reservations r
    INNER JOIN
        users u ON r.user_id = u.id
    INNER JOIN
        fields f ON r.field_id = f.id
    WHERE
        u.id = userId;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsPerOwnerByHour
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsPerOwnerByHour`(
    IN OwnerID INT,
    IN HourIn INT
)
BEGIN
    SELECT 
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
        AND HOUR(r.start_time) = HourIn
    ORDER BY 
        r.id ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsPerOwnerByMonth
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsPerOwnerByMonth`(
    IN OwnerID INT,
    IN MonthsAgo INT
)
BEGIN
    SELECT 
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
        AND r.date >= DATE_SUB(CURDATE(), INTERVAL MonthsAgo MONTH)
    ORDER BY 
        r.id ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsPerOwnerByMonthAndHour
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsPerOwnerByMonthAndHour`(
    IN OwnerID INT,
    IN MonthsAgo INT,
    IN Hour INT
)
BEGIN
    SELECT 
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
        AND r.date >= DATE_SUB(CURDATE(), INTERVAL MonthsAgo MONTH)
        AND HOUR(r.start_time) = Hour                               
    ORDER BY 
        r.id ASC;
	END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetReservationsWithLimitOffset
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetReservationsWithLimitOffset`(
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
SELECT * FROM reservations LIMIT p_limit OFFSET p_offset;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetUserByToken
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetUserByToken`(IN input_token VARCHAR(255))
BEGIN
    SELECT u.email, tke.token
    FROM users u
    INNER JOIN tokens_in_emails tke
        ON u.email = tke.email
    WHERE tke.token = input_token
    AND tke.expires_at > NOW()  -- Asegura que el token esté vigente
    ORDER BY tke.created_at DESC
    LIMIT 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetUsersByFavoriteField
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetUsersByFavoriteField`(
    IN fieldId INT
)
BEGIN
    SELECT u.first_name, u.email
    FROM `users` u
    JOIN `user_favorite_fields` uff ON u.id = uff.user_id
    WHERE uff.field_id = fieldId;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsertField
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `InsertField`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsertReservation
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `InsertReservation`(
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME,
    IN p_payment_id INT
)
BEGIN
    INSERT INTO reservations (field_id, user_id, date, start_time, end_time, payment_id)
    VALUES (p_field_id, p_user_id, p_date, p_start_time, p_end_time, p_payment_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PatchField
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `PatchField`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateField
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateField`(
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
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateReservation
-- -----------------------------------------------------

DELIMITER $$
USE `picadosya`$$
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateReservation`(
    IN p_id INT,
    IN p_field_id INT,
    IN p_user_id INT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME
)
BEGIN
UPDATE reservations
SET field_id = p_field_id, user_id = p_user_id, start_time = p_start_time, end_time = p_end_time
WHERE id = p_id;
END$$

DELIMITER ;
USE `picadosya`;

DELIMITER $$
USE `picadosya`$$
CREATE
DEFINER=`root`@`%`
TRIGGER `picadosya`.`after_insert_fields_update_user_role`
AFTER INSERT ON `picadosya`.`fields`
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
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
