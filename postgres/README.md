# Postgres for PuppetDB

## Introduction

Postgres is used as storage backend for PuppetDB. This image configures Postgres for
usage with PuppetDB.

## Usage

### Environment variables

none

## Details

* Ports exposed: 5432
* Volumes: /var/lib/postgresql/data
* Based on: `postgres:9.5.3`

### Entrypoint scripts

| Name          | Description                              |
| ----          | -----------                              |
| extensions.sh | Enables Postgres extensions for PuppetDB |
