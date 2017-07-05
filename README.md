# Puppet 5 Infrastructure - Running in Docker

**WARNING: These Dockerfiles are brand new - there is no field testing made yet.**
**This will be done over the following weeks. Then we'll also do a first release.**

## Introduction

This repository contains Dockerfiles for a complete Puppet 4 infrastructure
running in Docker. The following components are used:

* [**HAProxy**](http://www.haproxy.org/): Reverse proxy for splitting traffic between CA and catalog
  compilation
* [**Puppetserver**](https://docs.puppet.com/puppetserver/latest/): Latest version of Puppetserver for CA mode and catalog
  compilation only mode
* [**PuppetDB**](https://docs.puppet.com/puppetdb/latest/): Latest PuppetDB for storing reports, facts and exported resources
* [**Postgres**](https://www.postgresql.org/): Storage backend for PuppetDB
* [**r10k**](https://docs.puppet.com/pe/latest/r10k.html): Puppet code deployment, featuring MCollective support
* [**NATS**](https://nats.io/): Middleware for MCollective ([Choria](http://choria.io/))
* [**Puppet explorer**](https://github.com/spotify/puppetexplorer): Dashboard for insights into PuppetDB data

With the provided Docker Compose file all components can be started with a simple
`docker-compose up`. This will take some time, as all Docker images are created locally
and all components together use a lot of resources.

## Usage

All components can be run by themselves. Documentation about each component can be
found in their respective directory.

## Internals

### Docker Entrypoint

The Docker Entrypoint is always the same script: `docker-entrypoint.sh`. It takes
the process to be started as argument, which is by default set to the name of the
corresponding image (f.e. for HAProxy this would be `CMD ["haproxy"]`). It is
started using [dumb-init](https://github.com/Yelp/dumb-init/) for proper PID 1 handling.

Inside the entrypoint script, `run-parts` is used to call all scripts under
`/docker-entrypoint.d`. Theses scripts are then used to configured the service
during startup, like replacing config variables coming from the environment vars.
Most of the scripts implement a simple "wait" logic to wait until services they
depend on are started and accessible.

### Dockerfile

In the build process, the source `Dockerfile` file is added to `/` inside the image,
so it is alway possible to see how the image was built, even if the file got lost.

### Certificate Request

Several services need a certificate from the Puppet CA. Normally the certificate is
requested by the Puppet Agent, but it is not always available. Therefore there is
a script used, called `request-cert.rb` which implements the request and retrieval
process. Most of this script is extracted from [choria.rb](https://github.com/choria-io/mcollective-choria/blob/master/lib/mcollective/util/choria.rb).
Thanks a lot to R.I.Pienaar!

### Helper scripts

* To cleanup data, the script `cleanup-data.sh` can be used:
 * `cleanup-data.sh data`: removes data inside the volumes
 * `cleanup-data.sh volumes`: removes all docker volumes

## Puppet 3.x migration helper

To support migrating scenarios from older versions of Puppet, there are some Dockerfiles
available, suitably called `Dockerfile.legacy`. Also HAProxy supports CA connections
to old Puppet Master servers. It is possible for running a PuppetDB 2.3.x  which gets used
by Puppetserver and Puppet Master at the same time. This helps in migrating from
3.x to 4.x.

See `docker-compose-legacy.yaml` for an example Docker Compose file which only
starts components needed and connects to an Puppet 3.x infrastructure.

## Credits

Inspiration for these Dockerfiles are coming from several sources. Especially we'd like
to thank:

* Puppet for providing many good example Dockerfiles under [puppetlabs/puppet-in-docker](https://github.com/puppetlabs/puppet-in-docker)
* Camptocamp for providing nice [Dockerfiles](https://github.com/camptocamp?q=docker), [Rancher templates](https://github.com/camptocamp/camptocamp-rancher-catalog/tree/master/templates/puppet) and the idea for the
  [flexible Docker entrypoint](https://github.com/camptocamp/camptocamp-rancher-catalog/tree/master/templates/puppet) using `run-parts`.

## Known issues / Todo list

* Not all necessary bits and bytes are configurable at the moment. This will progress
  over the time.
* Not yet field-tested, this will happen over the next months.
