# HAProxy for Puppetserver access

[Docker Hub: `vshn/puppet-haproxy`](https://hub.docker.com/r/vshn/puppet-haproxy/)

## Introduction

This HAProxy is configured to split traffic between CA and compilation traffic.
It uses `confd` to write the HAProxy configuration. There is also a frontend configured
for PuppetDB access.

## Usage

### Environment variables

| Name                 | Description                                     | Default value      |
| ----                 | -----------------------------------------       | -------------      |
| CA_SERVER            | Puppet CA server to request certificate         | puppetca.local     |
| PUPPETCA_BACKEND     | Backend for Puppet CA traffic                   | puppetca.local     |
| PUPPETSERVER_BACKEND | Backend for everything but catalog compilation  | puppetserver.local |
| PUPPETSERVER_CATALOG_BACKEND | Backend for catalog compilation         | puppetserver.local |
| SKIP_CRL_DOWNLOAD    | If set to true, skips download of CRL from CA   | -                  |
| STATS_CRED           | HAProxy Statistics credentials                  | admin:password     |

## Details

* Ports exposed: 8140
* Additional ports: 9000 (statistics)
* Volumes: -
* Based on: `haproxy:1.7-alpine`
* HAProxy statistics: HTTP port 9000
* Syslog is started so that HAProxy logs are available on stdout

### Entrypoint scripts

| Name            | Description                                                         |
| ----            | -----------                                                         |
| 10-tls-setup.sh | Request a certificate from Puppet CA and prepare result for HAProxy |
| 20-confd.sh     | Configure HAProxy with confd - using haproxy.tmpl                   |
