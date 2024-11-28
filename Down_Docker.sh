#!/bin/bash

sudo docker compose -f docker-compose.yaml down

sudo docker image rm picadosya-app-frontend picadosya-app-backend

sudo docker volume rm picadosya-app_mysql_volume