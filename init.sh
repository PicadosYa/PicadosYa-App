#!/bin/bash

git checkout dev && git submodule update --init --recursive

cp .env.example ./.env && cp Backend/.env.template ./.env

./Project-up-dev.sh