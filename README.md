# DataOps PostgreSQL Lab

Este repositório é um laboratório prático de DBA/DataOps/Arquitetura de Dados aplicado a banco de dados PostgreSQL, com foco em versionamento de schema, migrations controladas e automação via pipeline.

O objetivo não é apenas “subir um banco”, mas sim simular práticas reais usadas em times de dados e plataforma: infraestrutura reproduzível, controle de mudanças e execução automatizada.

---

## Objetivos do Projeto

* Executar PostgreSQL em Docker de forma padronizada
* Versionar scripts SQL como código
* Aplicar migrations de forma controlada
* Garantir idempotência e rastreabilidade de schema
* Simular um pipeline de CI aplicando migrations automaticamente

---

## Arquitetura Geral

* **PostgreSQL** executando em container Docker
* **Scripts SQL** organizados por versão
* **Tabela de controle (`schema_version`)** para rastrear migrations
* **Scripts shell** para orquestração local
* **GitHub Actions** simulando pipeline de DataOps

---

## Estrutura do Repositório

```
dataops-postgres-lab/
├── docker/
│   └── docker-compose.yml
│
├── scripts/
│   ├── db_up.sh
│   ├── db_down.sh
│   └── run_migrations.sh
│
├── sql/
│   └── migrations/
│       ├── V001__init_schema.sql
│       └── V002__schema_version.sql
│
├── .github/
│   └── workflows/
│       └── migrations.yml
│
├── .gitignore
└── README.md
```

---

## Subindo o Banco de Dados

O PostgreSQL é iniciado via Docker Compose.

```
./scripts/db_up.sh
```

Esse script:

* Sobe o container PostgreSQL
* Garante nome e portas previsíveis
* Facilita reprodução do ambiente

Para derrubar o ambiente:

```
./scripts/db_down.sh
```

---

## Migrations SQL

As migrations seguem o padrão:

```
VXXX__descricao.sql
```

Exemplo:

* `V001__init_schema.sql`
* `V002__schema_version.sql`

Cada migration deve:

* Ser imutável após commit
* Representar uma mudança incremental no schema
* Ser executável de forma idempotente sempre que possível

---

## Controle de Versão de Schema

O projeto utiliza uma tabela de controle chamada `schema_version`.

Essa tabela registra:

* Versão aplicada
* Nome do script
* Data/hora de execução

Isso permite:

* Saber exatamente o estado do banco
* Evitar reaplicação de migrations
* Auditar mudanças de schema

---

## Execução de Migrations Local

Para aplicar as migrations manualmente:

```
./scripts/run_migrations.sh
```

O script:

* Conecta ao banco
* Executa as migrations em ordem
* Registra as versões aplicadas

---

## Pipeline (GitHub Actions)

O repositório possui um workflow que:

* Inicializa o ambiente
* Executa o script de migrations
* Simula um pipeline de DataOps

Arquivo:

```
.github/workflows/migrations.yml
```

O objetivo do pipeline não é deploy em produção, mas sim:

* Validar scripts SQL
* Garantir que migrations não quebrem
* Automatizar a evolução do schema

---

## Boas Práticas Aplicadas

* Infraestrutura como código
* SQL versionado em Git
* Separação clara entre código, scripts e infra
* Automação como parte do fluxo, não como etapa manual
* Documentação como parte do projeto

---

## Próximos Passos

* Seeds por ambiente (dev, stage, prod)
* Rollback controlado de migrations
* Validações automáticas no pipeline
* Evolução do modelo de dados

---

## Observação Final

Este projeto é um laboratório educacional com foco em práticas reais de DataOps e Engenharia de Dados.
Cada decisão foi pensada para refletir cenários comuns em ambientes corporativos.

---
