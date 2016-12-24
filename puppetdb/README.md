# PuppetDB

[Docker Hub: `vshn/puppet-puppetdb`](https://hub.docker.com/r/vshn/puppet-puppetdb/)

## Introduction

PuppetDB is used for storage backend for Puppetserver. This image configures PuppetDB
to be run in Docker.

## Usage

### Environment variables

| Name              | Description                               | Default value  |
| ----              | ----------------------------------------- | -------------  |
| CA_SERVER         | Puppet CA server to request certificate   | puppetca.local |
| POSTGRES_USER     | Username for Postgres connection          | -              |
| POSTGRES_PASSWORD | Password for Postgres user                | -              |

## Details

* Ports exposed: 8080 8081
* Volumes: -
* Based on: `ubuntu:16.04`

### Entrypoint scripts

| Name            | Description                                                           |
| ----            | -----------                                                           |
| 10-tls-setup.sh | Request a certificate from Puppet CA and configure PuppetDB to use it |
