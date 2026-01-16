#!/bin/bash
set -e

cd docker/postgres
docker compose up -d

echo "PostgreSQL iniciado."
