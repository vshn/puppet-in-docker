# PuppetDB

[Docker Hub: `vshn/puppet-puppetdb`](https://hub.docker.com/r/vshn/puppet-puppetdb/)

## Introduction

PuppetDB is used for storage backend for Puppetserver. This image configures PuppetDB
to be run in Docker.

## Usage

### Environment variables

| Name               | Description                                     | Default value  |
| ----               | -----------------------------------------       | -------------  |
| CA_SERVER          | Puppet CA server to request certificate         | puppetca.local |
| POSTGRES_PASSWORD  | Password for Postgres user                      | -              |
| POSTGRES_USER      | Username for Postgres connection                | -              |
| USE_LEGACY_CA_API  | If set to true, sets CA API URLs for Puppet 3.8 | -              |
| PUPPETDB_NODETTL   | PuppetDB node-ttl (default was 7d)              | 30d            |
| PUPPETDB_WHITELIST | Set to `true` to enable puppetdb whitelist      | - (false)      |

### PuppetDB Certificate Whitelist
By default any valid certificate from the CA can query anything that's in the PuppetDB.
This means puppet agents can query all the information for any other agent in the PuppetDB, too.

See: https://puppet.com/docs/puppetdb/5.2/configure.html#puppetdb-settings

*This is a big security issue* and you should limit PuppetDB access to *Puppetmasters* and other carefully selected systems.
Set Env `PUPPETDB_WHITELIST` to true and docker mount a whitelist to `/etc/puppetlabs/puppetdb/certificate-whitelist`

Certificates of normal puppet agents should never be on the whitelist!

## Details

* Ports exposed: 8080 8081
* Volumes: -
* Based on: `ubuntu:16.04`

### Entrypoint scripts

| Name            | Description                                                           |
| ----            | -----------                                                           |
| 10-tls-setup.sh | Request a certificate from Puppet CA and configure PuppetDB to use it |
| 20-whitelist.sh | Configures the use of a client certificate whitelist                  |
