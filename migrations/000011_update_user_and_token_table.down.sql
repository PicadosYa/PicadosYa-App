-- Elimina el procedimiento almacenado GetUserByToken
DROP PROCEDURE IF EXISTS GetUserByToken;

-- Renombra la tabla tokens_in_emails de vuelta a password_recovery_tokens
RENAME TABLE tokens_in_emails TO password_recovery_tokens;

-- Elimina la columna isVerified de la tabla users
ALTER TABLE `users`
DROP COLUMN `isVerified`;