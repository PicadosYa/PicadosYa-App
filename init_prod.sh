#!/bin/bash

# Verificar si se ingresó una IP como parámetro
if [[ -z "$1" ]]; then
  echo "Uso: ./update-configs.sh <nueva_ip>"
  exit 1
fi

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

# Verificación final
echo "Modificaciones completadas. Verifique los archivos para confirmar los cambios:"
echo "- $GLOBAL_FILE"
echo "- $API_FILE"
echo "- $VITE_FILE"
