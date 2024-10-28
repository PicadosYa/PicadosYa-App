#!/bin/bash

# Configuración del host, puerto, intervalo de espera y límite de tiempo
HOST="mysql"
PORT=3306
INTERVAL=10  # intervalo entre intentos (en segundos)
TIMEOUT=300  # tiempo máximo de espera (en segundos)
elapsed=0

# Cargar variables desde el archivo .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️  Error: Archivo .env no encontrado"
    echo "ℹ️  Por favor, crea un archivo .env con las siguientes variables:"
    echo "  - DB_USER=usuario"
    echo "  - DB_PASS=contraseña"
    echo "  - DB_DATABASE=nombre_base_datos"
    echo "  - BACKUP_PATH=/ruta/backups"
    exit 1
fi

# Verificar que todas las variables necesarias estén definidas
for var in "DB_USER" "DB_PASS" "DB_HOST" "DB_PORT" "DB_DATABASE" "BACKUP_PATH"; do
    if [ -z "$(eval echo \$$var)" ]; then
        echo "⚠️  Error: La variable $var no está definida en el archivo .env"
        exit 1
    fi
done

echo "Esperando a que MySQL esté disponible en $HOST:$PORT..."

# Espera hasta que MySQL esté disponible
while ! nc -z $HOST $PORT; do
  if [ $elapsed -ge $TIMEOUT ]; then
    echo "MySQL no está disponible después de $TIMEOUT segundos."
    exit 1
  fi
  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
  echo "Reintentando conexión a MySQL en $HOST:$PORT... tiempo transcurrido: ${elapsed}s"
done

echo "MySQL está disponible en $HOST:$PORT."

ls /migrations
# Ejecutar las migraciones
migrate -verbose -path /migrations -database "mysql://root:${DB_PASS}@tcp(${HOST}:${PORT})/${DB_DATABASE}" drop -f

migrate -verbose -path /migrations -database "mysql://root:${DB_PASS}@tcp(${HOST}:${PORT})/${DB_DATABASE}?multiStatements=true" up 
