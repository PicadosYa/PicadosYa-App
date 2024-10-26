#!/bin/bash

# Cargar variables desde .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: Archivo .env no encontrado"
    echo "Por favor, crea un archivo .env con las siguientes variables:"
    echo "DB_USER=usuario"
    echo "DB_PASS=contraseña"
    echo "DB_DATABASE=nombre_base_datos"
    echo "BACKUP_PATH=/ruta/backups"
    exit 1
fi

# Verificar que todas las variables necesarias estén definidas
for var in DB_USER DB_PASS DB_DATABASE BACKUP_PATH; do
    if [ -z "${!var}" ]; then
        echo "Error: La variable $var no está definida en el archivo .env"
        exit 1
    fi
done

LATEST_BACKUP="${BACKUP_PATH}/${DB_DATABASE}_latest.sql"
PRE_LATEST_BACKUP="${BACKUP_PATH}/${DB_DATABASE}_pre_latest.sql"
MAX_BACKUPS=2

# Crear directorio de backup si no existe
mkdir -p ${BACKUP_PATH}

# Verificar si existe un backup latest y renombrarlo con número aleatorio
if [ -f "${LATEST_BACKUP}" ]; then
    if [ -f "${PRE_LATEST_BACKUP}" ]; then
      RANDOM_NUM=$((RANDOM % 900 + 100))  # Genera número aleatorio entre 100 y 999
      mv "${PRE_LATEST_BACKUP}" "${BACKUP_PATH}/${DB_DATABASE}_${RANDOM_NUM}.sql"
      mv "${LATEST_BACKUP}" "${PRE_LATEST_BACKUP}"
    fi
    mv "${LATEST_BACKUP}" "${PRE_LATEST_BACKUP}"
fi

# Mantener solo los últimos 3 backups (excluyendo el latest)
cd ${BACKUP_PATH}
ls -t ${DB_DATABASE}_[0-9]*.sql 2>/dev/null | tail -n +${MAX_BACKUPS} | xargs -r rm
cd ..
# Realizar el dump completo
mysqldump \
  --user=${DB_USER} \
  --password=${DB_PASS} \
  --host=127.0.0.1 \
  --routines \
  --events \
  --triggers \
  --single-transaction \
  --add-drop-database \
  --create-options \
  --add-drop-table \
  --set-gtid-purged=OFF \
  --databases ${DB_DATABASE} > "${LATEST_BACKUP}"

# Verificar si el backup se realizó correctamente
if [ $? -eq 0 ]; then
    echo "Backup completado exitosamente: ${LATEST_BACKUP}"
    echo -e "\nBackups actuales en el directorio:"
    ls -lh ${BACKUP_PATH}/${DB_DATABASE}_*.sql | sed 's/^/  /'
else
    echo "Error al realizar el backup"
    rm -f "${LATEST_BACKUP}"  # Eliminar el archivo en caso de error
    exit 1
fi