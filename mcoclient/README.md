# MCollective Client Image feat. Choria and r10k Plugin

[Docker Hub: `vshn/puppet-mcoclient`](https://hub.docker.com/r/vshn/puppet-mcoclient/)

## Introduction

This image contains the MCollective client with the Choria and r10k plugin.
It's mainly useful for example to deploy Puppet code from a CI pipeline.

## Usage

### Environment variables

| Name                 | Description                              | Default value        |
| ----                 | -----------                              | -------------        |
| CA_CERTIFICATE       | Mandatory: content of ca certificate     | -                    |
| CA_SERVER            | Puppet CA server to request certificate  | puppetca.local       |
| CERTIFICATE          | Mandatory: content of client certificate | -                    |
| MCOLLECTIVE_CERTNAME | MCollective identity to use              | deployer.mcollective |
| NATS                 | FQDN and port of NATS server             | nats.local:4222      |
| PRIVATE_KEY          | Mandatory: content of private key        | -                    |
| PUPPETDB             | FQDN of PuppetDB                         | puppetdb.local       |
| PUPPETSERVER         | FQDN of Puppetserver                     | puppetserver.local   |
| SKIP_CERT_CONFIG     | If set to true, skips certificate config | -                    |

### MCollective client

There is a Docker Compose file available which helps to set the correct parameters.

For getting a client certificate initially, start the container with `SKIP_CERT_CONFIG`
set to true and use the Choria helper:

```
docker-compose run --rm -e SKIP_CERT_CONFIG=true deployer bash
choria enroll
cat .puppetlabs/etc/puppet/ssl/certs/$MCOLLECTIVE_CERTNAME.pem
cat .puppetlabs/etc/puppet/ssl/certs/ca.pem
cat .puppetlabs/etc/puppet/ssl/private_keys/$MCOLLECTIVE_CERTNAME.pem
```

Put the output of the `cat` into their respective environment variables in `docker-compose.yaml`.

The container is now ready. Example invocation of MCollective r10k:

```
docker-compose run --rm deployer mco r10k deploy <environment>
```

See [voxpupuli/puppet-r10k](https://github.com/voxpupuli/puppet-r10k#mcollective-support) for a
detailed documentation about the r10k plugin.


### Entrypoint scripts

| Name                     | Description                                  |
| ----                     | -----------                                  |
| 21-mcollective-config.sh | Configures the MCollective client on startup |
