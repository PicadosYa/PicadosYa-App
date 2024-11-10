-- Agregar columna 'age' a la tabla 'users'
ALTER TABLE users
ADD COLUMN age INT NOT NULL;

-- Actualizar la edad de usuarios específicos
UPDATE users SET age = 30 WHERE id = 1;
UPDATE users SET age = 25 WHERE id = 2;