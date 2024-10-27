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

mkdir actions-runner && cd actions-runner &&

curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz &&

echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900  actions-runner-linux-x64-2.320.0.tar.gz" | shasum -a 256 -c &&

tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz