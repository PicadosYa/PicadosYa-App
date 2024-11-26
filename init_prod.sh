#!/bin/bash

# Verificar si se ingresó una IP como parámetro
if [[ -z "$1" ]]; then
  echo "Uso: ./update-configs.sh <nueva_ip>"
  exit 1
fi

git submodule update --init --recursive

# Obtener la nueva IP desde el parámetro
NEW_IP="$1"

# Modificar el archivo Global.js
GLOBAL_FILE="Frontend/src/helpers/Global.js"
if [[ -f "$GLOBAL_FILE" ]]; then
  sed -i "s|http://localhost:8080/api/|http://$NEW_IP:8080/api/|g" "$GLOBAL_FILE"
  echo "Archivo $GLOBAL_FILE actualizado con la IP $NEW_IP."
else
  echo "Error: $GLOBAL_FILE no encontrado."
fi

# Modificar el archivo api.go
API_FILE="Backend/internal/api/api.go"
if [[ -f "$API_FILE" ]]; then
  sed -i "s|http://localhost:3000|http://$NEW_IP:80\", \"http://$NEW_IP|g" "$API_FILE"
  echo "Archivo $API_FILE actualizado con la IP $NEW_IP."
else
  echo "Error: $API_FILE no encontrado."
fi

# Modificar el archivo vite.config.js
VITE_FILE="Frontend/vite.config.js"
if [[ -f "$VITE_FILE" ]]; then
  sed -i "s|port: 3000|port: 80|g" "$VITE_FILE"
  echo "Archivo $VITE_FILE actualizado con el puerto 80."
else
  echo "Error: $VITE_FILE no encontrado."
fi

cp .env.prod .env && cp Backend/.env.template Backend/.env

# Ruta del archivo .env
ENV_FILE="Backend/.env"

# Verificar si el archivo .env existe
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: El archivo $ENV_FILE no existe."
  exit 1
fi

# Modificar APP_BASE_URL
sed -i "s|http://localhost:8080|http://$NEW_IP:8080|g" "$ENV_FILE"
echo "APP_BASE_URL actualizado a http://$NEW_IP:8080."

# Modificar DB_HOST, DB_PORT y DB_USER
sed -i "s|DB_HOST=127.0.0.1|DB_HOST=mysql|g" "$ENV_FILE"
sed -i "s|DB_PORT=3307|DB_PORT=3306|g" "$ENV_FILE"
sed -i "s|DB_USER=root|DB_USER=picadosya|g" "$ENV_FILE"
echo "DB_HOST, DB_PORT y DB_USER actualizados."

# Verificación final
echo "Modificaciones completadas. Verifique los archivos para confirmar los cambios:"
echo "- $GLOBAL_FILE"
echo "- $API_FILE"
echo "- $VITE_FILE"

echo "Modificaciones completadas en el archivo $ENV_FILE. Los cambios son:"
echo "- APP_BASE_URL: http://$NEW_IP:8080"
echo "- DB_HOST: mysql"
echo "- DB_PORT: 3306"
echo "- DB_USER: picadosya"

# sudo docker compose -f docker-compose.prod.yml up -d