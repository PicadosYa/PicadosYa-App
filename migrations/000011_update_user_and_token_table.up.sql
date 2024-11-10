ALTER TABLE `users`
ADD COLUMN `isVerified` BOOLEAN NOT NULL DEFAULT FALSE;

RENAME TABLE password_recovery_tokens TO tokens_in_emails;

CREATE PROCEDURE GetUserByToken(IN input_token VARCHAR(255))
BEGIN
    SELECT u.email, tke.token
    FROM users u
    INNER JOIN tokens_in_emails tke
        ON u.email = tke.email
    WHERE tke.token = input_token
    AND tke.expires_at > NOW()  -- Asegura que el token esté vigente
    ORDER BY tke.created_at DESC
    LIMIT 1;
END;