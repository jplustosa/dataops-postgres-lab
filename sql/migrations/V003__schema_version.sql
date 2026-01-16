CREATE SCHEMA IF NOT EXISTS infra;

CREATE TABLE IF NOT EXISTS infra.schema_version (
    version        INTEGER PRIMARY KEY,
    description    TEXT NOT NULL,
    applied_at     TIMESTAMP NOT NULL DEFAULT now()
);
