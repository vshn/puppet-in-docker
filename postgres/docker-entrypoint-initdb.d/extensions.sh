#!/usr/bin/env bash

set -x
set -e

PSQL="psql -U puppetdb"

$PSQL puppetdb -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
$PSQL puppetdb -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
