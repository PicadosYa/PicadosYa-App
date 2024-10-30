#!/bin/bash

# Verificar si el archivo .env existe
if [ ! -f ".env" ]; then
  echo "❌ .env file not found. Please create one based on .env.example"
  exit 1
fi

echo "✅ .env file found."

# Verificar que todas las variables de .env.example están en .env
missing_vars=false
while IFS= read -r line; do
  if [[ -n "$line" && ! "$line" =~ ^# ]]; then
    var_name=$(echo "$line" | cut -d '=' -f 1)
    if ! grep -q "^$var_name=" .env; then
      echo "⚠️ Missing environment variable: $var_name in .env"
      missing_vars=true
    fi
  fi
done < .env.example

# Salir si faltan variables en el archivo .env
if [ "$missing_vars" = true ]; then
  echo "❌ Please add the missing variables to .env before running this script. See .env.example for reference."
  exit 1
fi

echo "✅ All required environment variables are set."

# Levantar servicios con Docker Compose
echo "🐳 Starting Docker Compose services..."
docker-compose up -d
if [ $? -ne 0 ]; then
  echo "❌ Docker Compose failed to start services."
  exit 1
fi
echo "✅ Docker Compose services started."

