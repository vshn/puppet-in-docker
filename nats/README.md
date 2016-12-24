# NATS - Messaging middleware for MCollective

[Docker Hub: `vshn/puppet-nats`](https://hub.docker.com/r/vshn/puppet-nats/)

## Introduction

NATS is used as messaging middleware for MCollective. The installation is using
the [Choria Orchestrator](https://github.com/ripienaar/mcollective-choria) which by default
uses NATS.

## Usage

### Environment variables

| Name                 | Description                               | Default value      |
| ----                 | ----------------------------------------- | -------------      |
| CA_SERVER            | Puppet CA server to request certificate   | puppetca.local     |

## Details

* Ports exposed: 4222 6222 8222
* Volumes: -
* Based on: `alpine:3.4`

### Entrypoint scripts

| Name            | Description                          |
| ----            | -----------                          |
| 10-tls-setup.sh | Request a certificate from Puppet CA |
