#!/bin/bash

check_exit_code() {
    if [ $? -eq 0 ]; then
    echo "$2" >> logs.txt && printf "\n" >> logs.txt
    elif [ $? -ne 0 ]; then
    echo "Ah ocurrido un error: $1" >> logs.txt && printf "\n" >> logs.txt
    exit 1
    fi
}

git clone https://github.com/AGuekdjian/Scripts.git && mv ./Scripts/installDocker.sh . && rm -rf ./Scripts
check_exit_code "Error al clonar el repositorio de scripts" "Clonando repositorio scripts, extrayendo instalador de docker y eliminando archivos o directorios inecesarios"

./installDocker.sh && rm -rf ./installDocker.sh
check_exit_code "Fallo la instalacion de Docker" "instalando Docker y eliminando archivos y directorios inecesarios."



cat <<EOL | sudo tee /etc/systemd/system/github-runner.service
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/actions-runner
ExecStart=/home/ubuntu/actions-runner/run.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL
