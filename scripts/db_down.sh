#!/bin/bash
set -e

cd docker/postgres
docker compose down

echo "PostgreSQL parado."
