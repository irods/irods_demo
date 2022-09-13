#!/bin/bash

# Adapted from "Initialization script" in documentation for official Postgres dockerhub:
#   https://hub.docker.com/_/postgres/
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER metalnx WITH PASSWORD 'changeme';
    CREATE DATABASE "irods-ext";
    GRANT ALL PRIVILEGES ON DATABASE "irods-ext" TO metalnx;
EOSQL
