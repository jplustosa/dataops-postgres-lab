# DataOps PostgreSQL Lab

> Production-oriented laboratory for versioned database delivery, controlled migrations and CI validation.

**PostgreSQL · Docker · SQL · Shell · GitHub Actions · DataOps**

## Problem

Database changes are operational changes. Executing SQL manually makes schema evolution harder to reproduce, audit and validate.

This project simulates a controlled database delivery workflow where schema changes are versioned in Git, executed in order and validated automatically in CI.

## Architecture

```text
Developer
   |
   v
Git repository
   |
   v
Versioned SQL migrations
   |
   +------------------+
   |                  |
   v                  v
Local PostgreSQL    GitHub Actions
   |                  |
   v                  v
schema_version    Migration validation
   |                  |
   +--------+---------+
            |
            v
      Auditable schema state
```

## Engineering goals

- Reproducible PostgreSQL environment.
- Database changes treated as code.
- Ordered and controlled migrations.
- Schema state and execution history tracked.
- CI validation before changes are considered deliverable.
- Configuration separated from source code.

## Repository structure

```text
dataops-postgres-lab/
├── docker/
│   └── docker-compose.yml
├── scripts/
│   ├── db_up.sh
│   ├── db_down.sh
│   └── run_migrations.sh
├── sql/
│   └── migrations/
│       ├── V001__init_schema.sql
│       └── V002__schema_version.sql
├── .github/
│   └── workflows/
│       └── migrations.yml
└── README.md
```

## Migration strategy

Migrations follow the convention:

```text
VXXX__description.sql
```

Examples:

- `V001__init_schema.sql`
- `V002__schema_version.sql`

A migration should be incremental, reviewed and immutable after application. The `schema_version` table provides an audit trail containing the applied version, script name and execution timestamp.

## Quick start

```bash
./scripts/db_up.sh
./scripts/run_migrations.sh
```

To stop the environment:

```bash
./scripts/db_down.sh
```

## CI/CD

The GitHub Actions workflow initializes PostgreSQL and executes the migration process automatically.

The pipeline validates that database changes can be applied in a clean environment and provides an executable safety net for future schema changes.

Recommended evolution:

```text
Lint SQL
   ↓
Start PostgreSQL
   ↓
Apply migrations
   ↓
Run integration checks
   ↓
Validate schema
   ↓
Security / quality checks
```

## Why this matters in DataOps

The objective is to establish a repeatable contract between development and database operations:

**Change → Validate → Apply → Audit**

This pattern reduces manual intervention and makes schema evolution observable and reproducible.

## Current limitations

This is a laboratory rather than a production migration framework. Planned improvements include:

- Rollback strategy.
- Checksums for migration immutability.
- Dev/stage/prod environment simulation.
- Integration tests for schema contracts.
- Migration drift detection.
- Better failure handling and transaction boundaries.
- Security and secret scanning in CI.
