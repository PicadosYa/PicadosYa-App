#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Verificar si se proporcionaron los parámetros necesarios
if [ $# -lt 2 ]; then
    echo "Error: Debes proporcionar el comando (down/force) y el número"
    echo "Uso: ./drop_migration.sh [down/force] [número]"
    echo "Ejemplo: ./drop_migration.sh down 1"
    echo "Ejemplo: ./drop_migration.sh force 5"
    exit 1
fi

# Validar que el primer parámetro sea 'down' o 'force'
if [ "$1" != "down" ] && [ "$1" != "force" ]; then
    echo "Error: El primer parámetro debe ser 'down' o 'force'"
    echo "Uso: ./drop_migration.sh [down/force] [número]"
    exit 1
fi

# Validar que el segundo parámetro sea un número
if ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo "Error: El segundo parámetro debe ser un número"
    echo "Uso: ./drop_migration.sh [down/force] [número]"
    exit 1
fi

cd $SCRIPT_DIR
cd ..

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️  Error: Archivo .env no encontrado"
    echo "ℹ️  Por favor, crea un archivo .env con las siguientes variables:"
    echo "  - DB_USER=usuario"
    echo "  - DB_PASS=contraseña"
    echo "  - DB_DATABASE=nombre_base_datos"
    exit 1
fi

# 🔍 Verificar que todas las variables necesarias estén definidas
for var in DB_USER DB_PASS DB_PORT DB_DATABASE; do
    if [ -z "${!var}" ]; then
        echo "⚠️  Error: La variable $var no está definida en el archivo .env"
        exit 1
    fi
done




# Asignar permisos al directorio de migraciones
sudo chown -R $USER:$USER migrations/

# Ejecutar el comando de migración
echo "Ejecutando migración: $1 $2"
docker run --user $(id -u):$(id -g) \
    -v $(pwd)/migrations:/migrations \
    --network host \
    migrate/migrate \
    -verbose \
    -path /migrations \
    -database "mysql://root:${DB_PASS}@tcp(127.0.0.1:${DB_PORT})/${DB_DATABASE}" \
    $1 $2

# Verificar si el comando se ejecutó correctamente
if [ $? -eq 0 ]; then
    echo "Comando '$1 $2' ejecutado exitosamente"
else
    echo "Error al ejecutar el comando '$1 $2'"
fi