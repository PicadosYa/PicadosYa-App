#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Verificar si se proporcionó un nombre para la migración
if [ -z "$1" ]; then
    echo "Error: Debes proporcionar un nombre para la migración"
    echo "Uso: ./create_migration.sh nombre_de_la_migracion"
    exit 1
fi

cd $SCRIPT_DIR
cd ..

# Asignar permisos al directorio de migraciones
sudo chown -R $USER:$USER migrations/

# Ejecutar el comando de migración con el nombre proporcionado
docker run --user $(id -u):$(id -g) -v $(pwd)/migrations:/migrations --network host migrate/migrate create -ext sql -dir /migrations -seq "$1"

# Verificar si el comando se ejecutó correctamente
if [ $? -eq 0 ]; then
    echo "Migración '$1' creada exitosamente"
else
    echo "Error al crear la migración"
fi