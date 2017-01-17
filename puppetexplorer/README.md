# Puppetexplorer

[Docker Hub: `vshn/puppet-puppetexplorer`](https://hub.docker.com/r/vshn/puppet-puppetexplorer/)

## Introduction

Puppetexplorer gives an overview what's going on in the PuppetDB. It is a
HTML5/JavaScript application which runs purely in the browser. The PuppetDB
API is accessed through a reverse proxy which is mounted at `/api`.

The Nginx running inside this image doesn't have any access control nor does
it provide SSL. This needs to be done in a frontend reverse proxy like the
HAproxy which is also available in this repository.

## Usage

### Environment variables

| Name            | Description                                                 | Default value  |
| ----            | -----------                                                 | -------------  |
| PUPPETDB_SERVER | Hostname of PuppetDB to which the reverse proxy connects to | puppetdb.local |

## Details

* Ports exposed: 8080
* Volumes: -
* Based on: `nginx:alpine`

### Entrypoint scripts

| Name               | Description      |
| ----               | -----------      |
| 20-nginx-config.sh | Configures Nginx |
