# Puppetserver

[Docker Hub: `vshn/puppet-puppetserver`](https://hub.docker.com/r/vshn/puppet-puppetserver/)

## Introduction

Puppetserver image for running Puppetserver in Docker. Can be configured to be a CA or
a compiler only.

## Usage

### Environment variables

| Name                        | Description                                     | Default value  |
| ----                        | -----------------------------------------       | -------------- |
| AUTOSIGN                    | Puppet CA autosign configuration                | true           |
| CA                          | When "enabled" CA service will be enabled       | disabled       |
| CA_SERVER                   | Puppet CA server to request certificate         | puppetca.local |
| CN                          | CN for certificate request                      | $hostname      |
| HIERA_BASE64                | Base64 encoded Hiera configuration              | -              |
| PUPPETDB_SERVER_URL         | URL to PuppetDB                                 | -              |
| PUPPETSERVER_JRUBYINSTANCES | Number of JRuby instances, set to #cpu + 2      | 2              |
| PUPPET_ENC                  | Configuration for external_nodes                | -              |
| SKIP_CRL_DOWNLOAD           | If set to true, skips download of CRL from CA   | -              |
| CA_NAME                     | The CN of the generated Puppet CA certificate   | -              |
| CA_TTL                      | Expire TTL of newly created certs by the CA     | 5y             |


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

### Puppet4

The main build is for Puppet 5 with PuppetDB 5. If you need Puppet 4 with PuppetDB 5 support, use the `Dockerfile.puppet4` which uses
puppetdb-termini version 4.4.x

Support for older PuppetDB versions and support for Puppet 3.8 has been removed.  

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
