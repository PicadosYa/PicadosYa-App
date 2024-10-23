-- ====================================================
-- Crea la base de datos principal si no existe
-- ====================================================
CREATE DATABASE IF NOT EXISTS app_picadosYa;

-- Usar la base de datos creada
USE app_picadosYa;

-- ====================================================
-- Tabla de usuarios
-- Almacena información de clientes, propietarios y administradores
-- ====================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL, -- Contraseña hasheada
    telefono VARCHAR(20),
    foto_url VARCHAR(255), -- URL a la foto de perfil
    rol ENUM('cliente', 'propietario', 'admin') NOT NULL, -- Rol de usuario
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar usuario administrador por defecto
INSERT IGNORE INTO usuarios (nombre, apellido, correo_electronico, contrasena, rol) 
VALUES ('Admin', 'Admin', 'admin@picadosya.com', 'hashed_password', 'admin');

-- ====================================================
-- Tabla de canchas
-- Almacena información de las canchas registradas por los propietarios
-- ====================================================
CREATE TABLE IF NOT EXISTS canchas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propietario_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    latitud DECIMAL(10, 8), -- Coordenada de latitud para geolocalización
    longitud DECIMAL(11, 8), -- Coordenada de longitud para geolocalización
    tipo ENUM('5', '7', '11') NOT NULL, -- Tipo de cancha según número de jugadores
    precio DECIMAL(10, 2) NOT NULL, -- Precio por reserva
    descripcion TEXT,
    logo_url VARCHAR(255), -- URL al logo de la cancha
    calificacion_promedio DECIMAL(3, 2) DEFAULT 0, -- Promedio de calificaciones de usuarios
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (propietario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índices para mejorar la búsqueda por ubicación y tipo
CREATE INDEX idx_canchas_ubicacion ON canchas (latitud, longitud);
CREATE INDEX idx_canchas_tipo ON canchas (tipo);

-- ====================================================
-- Tabla de fotos de canchas
-- Almacena las URLs de las fotos asociadas a cada cancha
-- ====================================================
CREATE TABLE IF NOT EXISTS canchas_fotos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cancha_id INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    FOREIGN KEY (cancha_id) REFERENCES canchas(id) ON DELETE CASCADE
);

-- ====================================================
-- Tabla de horarios disponibles de las canchas
-- Almacena los horarios en los que una cancha está disponible
-- ====================================================
CREATE TABLE IF NOT EXISTS canchas_horarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cancha_id INT NOT NULL,
    dia_semana ENUM('lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (cancha_id) REFERENCES canchas(id) ON DELETE CASCADE
);

-- Índice para mejorar la búsqueda por cancha y día de la semana
CREATE INDEX idx_horarios_cancha_dia ON canchas_horarios (cancha_id, dia_semana);

-- ====================================================
-- Tabla de reservas
-- Almacena las reservas realizadas por los clientes
-- ====================================================
CREATE TABLE IF NOT EXISTS reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cancha_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado ENUM('reservada', 'cancelada', 'completada') DEFAULT 'reservada',
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cancha_id) REFERENCES canchas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índice para evitar reservas duplicadas en el mismo horario y cancha
CREATE UNIQUE INDEX idx_reservas_unicas ON reservas (cancha_id, fecha, hora_inicio, hora_fin);

-- ====================================================
-- Tabla de pagos
-- Almacena la información de los pagos realizados por los clientes
-- ====================================================
CREATE TABLE IF NOT EXISTS pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    usuario_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    metodo_pago ENUM('mercadopago') NOT NULL,
    estado ENUM('pendiente', 'completado', 'fallido') DEFAULT 'pendiente',
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mercadopago_id VARCHAR(255), -- ID de la transacción en MercadoPago
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índice para búsqueda rápida por estado de pago
CREATE INDEX idx_pagos_estado ON pagos (estado);

-- ====================================================
-- Tabla de calificaciones y comentarios de canchas
-- Almacena las calificaciones y comentarios realizados por los clientes sobre las canchas
-- ====================================================
CREATE TABLE IF NOT EXISTS canchas_calificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cancha_id INT NOT NULL,
    usuario_id INT NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5), -- Calificación de 1 a 5
    comentario TEXT,
    fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cancha_id) REFERENCES canchas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índice para mejorar la consulta de calificaciones por cancha
CREATE INDEX idx_calificaciones_cancha ON canchas_calificaciones (cancha_id);

-- ====================================================
-- Tabla de sesiones
-- Gestiona las sesiones de los usuarios (opcional)
-- ====================================================
CREATE TABLE IF NOT EXISTS sesiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ====================================================
-- Tabla de notificaciones
-- Almacena las notificaciones enviadas a los usuarios
-- ====================================================
CREATE TABLE IF NOT EXISTS notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo ENUM('reserva_confirmada', 'reserva_cancelada', 'otro') NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índice para mejorar la consulta de notificaciones por usuario
CREATE INDEX idx_notificaciones_usuario ON notificaciones (usuario_id, leido);

-- ====================================================
-- Tabla de registros de exportación
-- Registra las acciones de exportación realizadas por los propietarios
-- ====================================================
CREATE TABLE IF NOT EXISTS export_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propietario_id INT NOT NULL,
    tipo_export ENUM('csv', 'otro') NOT NULL,
    fecha_export TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (propietario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ====================================================
-- Tabla de estadísticas de ventas
-- Almacena datos para generar informes y gráficos de ventas
-- ====================================================
CREATE TABLE IF NOT EXISTS estadisticas_ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propietario_id INT NOT NULL,
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    anio INT NOT NULL,
    total_reservas INT DEFAULT 0,
    ingresos DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (propietario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Índice para mejorar la consulta de estadísticas por propietario, año y mes
CREATE INDEX idx_estadisticas_propietario_fecha ON estadisticas_ventas (propietario_id, anio, mes);