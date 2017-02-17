# r10k including MCollective

[Docker Hub: `vshn/puppet-r10k`](https://hub.docker.com/r/vshn/puppet-r10k/)

## Introduction

r10k is used for Puppet code deployment. It features integration with MCollective so that
r10k runs can be triggered from remote.
Installation and configuration of MCollective Choria and r10k is done using the
Puppet modules (`puppet apply`):

* [choria-mcollective](https://forge.puppet.com/choria/mcollective)
* [puppet-r10k](https://forge.puppet.com/puppet/r10k)

Configuration is saved in `config/common.yaml` and applied during image build.

A MCollective policy is installed for r10k, explicitly allow anyone to call the r10k
command. This needs adjustment for a production installation!

## Usage

### Environment variables

| Name                   | Description                                                     | Default value        |
| ----                   | -----------                                                     | -------------        |
| CA_SERVER              | Puppet CA server to request certificate                         | puppetca.local       |
| MCO_R10K_POLICY        | Choria policy for r10k plugin                                   | policy default allow |
| R10K_DEPLOY_KEY        | SSH key for accessing private git repositories                  | -                    |
| R10K_DEPLOY_KEY_BASE64 | SSH key for accessing private git repositories (Base64 encoded) | -                    |
| R10K_REPO              | r10k control repository                                         | -                    |
| USE_LEGACY_CA_API      | If set to true, sets CA API URLs for Puppet 3.8                 | -                    |
| PUPPETDB               | Hostname of PuppetDB                                            | puppetdb.local       |
| PUPPETSERVER           | Hostname of Puppetserver                                        | puppetserver.local   |
| NATS                   | Hostname of NATS Server                                         | nats.local:4222      |

### r10k configuration

r10k is configured using a configuration file saved inside the image. This repository
contains a simpile configuration file which is not useable for production. Setting the
environment variable `R10K_REPO` is therefore mandatory.

To further customize the r10k configuration, you must create your own Docker image.
Example:

```
FROM vshn/puppet-r10k
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
```

The cache directory specified in the r10k.yaml configuration file should be defined
as Docker volume. In the default configuration this is `/opt/puppetlabs/r10k/cache`.

For checking out code from a private git repository a SSH deploy key is most likely
needed. It can be configured with the environment variable `R10K_DEPLOY_KEY` or
mounted to `/root/.ssh/id_rsa`.

### Code sharing with Puppetserver

The code checked out by r10k is saved under `/etc/puppetlabs/code/environments`. This
directory should be defined as volume and shared with the Puppetserver container.

Example with Docker Compose:

```
  puppetserver:
    volumes:
      - r10k_env:/etc/puppetlabs/code/environments/
  r10k:
    volumes:
      - r10k_env:/etc/puppetlabs/code/environments
```

### MCollective

To use MCollective, you need a certificate and a client configuration. This can be tested
in the r10k image:

```
docker-compose exec r10k bash
adduser --disabled-password --gecos "" myuser
su - myuser
mco choria request_cert
mco ping
mco r10k deploy <MYENVIRONMENT>
```

**Note**: Using an MCollective client as root is not supported.

The default configuration in this image allow every user with access to MCollective
to issue r10k commands. To customize this policy, override it in the environment
variable `MCO_R10K_POLICY`.

### MCollective Git Agent

Some data may not be deployed by r10k but by plain Git. Therefore there is a simple
MCollective Agent available for calling Git operations over MCollective. A small
helper for a simple Git submodule is also available, called [GWS](https://streakycobra.github.io/gws/).

Example usage of the MCO Git Agent:

```
mco rpc git cln repo=https://github.com/myorg/myrepo.git path=/tmp/clone
mco rpc git run command=pull path=/tmp/clone arg='origin master'
mco rpc git gws command=update path=/tmp/clone
```

#### Command: `cln`

Basically: `git clone`

| Parameter | Description                |
| --------- | -----------                |
| repo      | Source repository to clone |
| path      | Path to clone to           |

#### Command: `run`

Basically: `git <command>`. The only allowed commands are:

* pull
* reset
* checkout

| Parameter | Description                |
| --------- | -----------                |
| command   | Git command to run         |
| arg       | Argument(s) to the command |
| path      | Path to the git repository |

#### Command: `gws`

Basically: `gws <command>`. The only allowed commands are:

* update
* ff
* check

| Parameter | Description               |
| --------- | -----------               |
| command   | GWS command to run        |
| path      | Path to the git workspace |

## Details

* Ports exposed: -
* Volumes: -
* Based on: `ubuntu:16.04`

### Entrypoint scripts

| Name              | Description                                                  |
| ----              | -----------                                                  |
| 10-tls-setup.sh   | Request a certificate from Puppet CA for MCollective service |
| 20-r10k-config.sh | Configures contro repo, deploy key and mco policy            |
