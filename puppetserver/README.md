# Puppetserver

[Docker Hub: `vshn/puppet-puppetserver`](https://hub.docker.com/r/vshn/puppet-puppetserver/)

## Introduction

Puppetserver image for running Puppetserver in Docker. Can be configured to be a CA or
a compiler only.

## Usage

### Environment variables

| Name                | Description                                     | Default value  |
| ----                | -----------------------------------------       | -------------- |
| AUTOSIGN            | Puppet CA autosign configuration                | true           |
| CA                  | When "enabled" CA service will be enabled       | disabled       |
| CA_SERVER           | Puppet CA server to request certificate         | puppetca.local |
| CN                  | CN for certificate request                      | $hostname      |
| HIERA_BASE64        | Base64 encoded Hiera configuration              | -              |
| PUPPETDB_SERVER_URL | URL to PuppetDB                                 | -              |
| PUPPET_ENC          | Configuration for external_nodes                | -              |
| SKIP_CRL_DOWNLOAD   | If set to true, skips download of CRL from CA   | -              |
| USE_LEGACY_CA_API   | If set to true, sets CA API URLs for Puppet 3.8 | -              |
| USE_LEGACY_PUPPETDB | If set to true, uses PuppetDB 2.3 URL           | -              |

**Support for arbitrary configuration in puppet.conf**:

Use environment variables starting with `PUPPETCONF_` to add configuration values to `puppet.conf`.
They are in this format: `PUPPETCONF_<SECTION>_<KEY>=<VALUE>`.

Example:

```
PUPPETCONF_MASTER_ENVIRONMENT_TIMEOUT=unlimited
```

This will add `enviroment_timeout = unlimited` to `puppet.conf` in the section `[master]`.

### Puppetserver configuration

Default configuration files are saved under `config/` and are copied into the image
during the build process. To overwrite these files and put the own customized
configuration into the image (like the Hiera structure) the best way is to build
a new image. Example:

```
FROM vshn/puppet-puppetserver:latest
COPY hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
```

Other scripts, f.e. a custom ENC provider should also be copied into the image
using this way.

### Support for PuppetDB 2.3.x

To support migration scenarios there is a special Dockerfile available, suitably
called `Dockerfile.legacy`. It installs `puppetdb-terminus` from the old Puppetlabs
Apt repository (instead of `puppetdb-termini`).

## Details

* Ports exposed: 8140
* Volumes: -
* Based on: `ubuntu:16.04`

### Entrypoint scripts

| Name                           | Description                                                         |
| ----                           | -----------                                                         |
| 10-configure-ca.sh             | Configures CA behavior - if disabled requests a certificate from CA |
| 20-puppetdb.sh                 | Configures connection to PuppetDB if PUPPETDB_SERVER_URL is set     |
| 30-enc.sh                      | Configures the ENC to be used                                       |
| 31-hiera.sh                    | Configures Hiera                                                    |
| 40-external-tls-termination.sh | Preparation for allowing SSL termination on HAProxy                 |
| 50-disable-legacy-auth.sh      | Sets `use-legacy-auth-conf: false`                                  |
