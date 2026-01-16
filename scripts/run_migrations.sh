#!/bin/bash
set -e

# --- Resolve paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

MIGRATIONS_DIR="$PROJECT_ROOT/sql/migrations"

DB_CONTAINER="postgres_dataops_lab"
DB_USER="dataops"
DB_NAME="labdb"

echo "Iniciando controle de migrations..."

# --- Garante que a tabela de versionamento existe ---
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" <<EOF
CREATE SCHEMA IF NOT EXISTS infra;
CREATE TABLE IF NOT EXISTS infra.schema_version (
    version INTEGER PRIMARY KEY,
    description TEXT NOT NULL,
    applied_at TIMESTAMP NOT NULL DEFAULT now()
);
EOF

# --- Obtém última versão aplicada ---
LAST_VERSION=$(docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c \
"SELECT COALESCE(MAX(version), 0) FROM infra.schema_version;" | tr -d '[:space:]')

echo "Última versão aplicada: V$LAST_VERSION"

# --- Aplica migrations pendentes ---
for file in $(ls "$MIGRATIONS_DIR"/V*.sql | sort); do
    filename=$(basename "$file")
    version=$(echo "$filename" | cut -d'_' -f1 | sed 's/V//')
    description=$(echo "$filename" | cut -d'_' -f2- | sed 's/\.sql//')

    if [ "$version" -le "$LAST_VERSION" ]; then
        echo "Pulando $filename (já aplicada)"
        continue
    fi

    expected_version=$((LAST_VERSION + 1))

    if [ "$version" -ne "$expected_version" ]; then
        echo "ERRO: tentativa de pular versão. Esperado V$expected_version, encontrado V$version"
        exit 1
    fi

    echo "Aplicando migration $filename"

    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$file"

    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
    "INSERT INTO infra.schema_version (version, description)
     VALUES ($version, '$description');"

    LAST_VERSION=$version
done

echo "Migrations finalizadas com sucesso."
