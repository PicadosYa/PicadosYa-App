#!/bin/bash

docker compose -f docker-compose.prod.yml down

docker image rm picadosya-app-frontend picadosya-app-backend

docker volume rm picadosya-app_mysql_volume