# Changelog
Please document all notable changes to this project in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## v3.6.0
### Changed
- Use a the vshn hiera.yaml
- Use up2date puppetserver and puppetdb-termini version
- Replace Puppetserver 6.4 with 6.7

### Fixed
- Ruby dependency issue with puppet-agent version for puppetserver 6

### Remove

## v3.5.1
### Fix
- Update to puppet-r10 module version 7.0.0 - 6.x no longer available

## v3.5.0
This release improves the images so they can be used better on kubernetes.
It should not break backwards compatibility with normal docker setups, 
all default configuration values should stay the same.

### Added
- Support splitting of catalog request to other puppetserver
- Support haproxy logs to syslog UDP
- Install VSHN ENC from PPA vshn/puppetserver-tools
- Support configuration of Puppet 5 CA api endpoint allow rule
- Support configuration of PuppetDB report-ttl and connection-timeout

### Removed
- PuppetDB backend from haproxy
- Puppetexplorer

## v3.4.0
### Changed
- Use latest puppetserver 5.3.8, with puppetdb-termini 5.2.9
- Use latest puppetserver 6.4.0, with puppetdb-termini 6.3.4
- Use latest puppetdb 6.3.4
- Use latest puppet 5.5.14 for mcoclient and r10k

### Removed
- Drop support for puppetserver 6.1
- Drop support for puppetdb 6.1

## v3.3.0
### Changed
- Higher mco r10kcli timeouts because global lock delays execution more

## v3.2.1
### Changed
- Acquire global lock before executing r10k for any environment, not a lock per
  environment

## v3.2.0
### Changed
- Acquire lock before executing r10k

## v3.1.0
### Fixed
- Configure choria allow_unconfigured because default changed in choria-plugins/action-policy 3.1.0

## v3.0.2
### Fixed
- Fix openssl dependency in ruby request-cert scripts

## v3.0.1
### Changed
- puppetserver and puppetdb Dockerfile can now build other versions via build-args
- Update r10k components to current versions
- Update nats components, add nats to gitlab-ci
- Update README

### Added
- gitlab-ci config to build and push to dockerhub
- gitlab-ci config for haproxy
- gitlab-ci for postgres build

### Removed
- Support for legacy PuppetDB API
- Puppet 4 Server Dockerfile
- Remains of Puppet 3.8 and more legacy API

## v2.4.0
### Added
- manage maximum-pool-size setting, default value 25

### Changed
- Update PuppetDB from 5.1.3 to 5.1.5

## v2.3.1
### Fixed
- Fix gettext-setup issue, puppetlabs/SERVER-1912

## v2.3.0
### Added
- Implement certificate-whitelist for PuppetDB

## v2.2.0
### Fixed
- Incompatible versions of mcoclient and r10k choria plugin

### Added
- r10k cli rpc agent for mco

## v2.1.0
### Added
- Make CA CN and TTL configurable

## v2.0.0 - 2018-02-05
### Changed
- Removed deprecated PuppetDB settings
- Removed Puppet 3.8

### Added
- Make PuppetDB node-ttl configurable
- Add Dockerfile for Puppet4 with PuppetDB5

## v1.2.0 - 2018-01-04
### Added
- Updated all components to Puppet 5
- Environment variable to configure number of JRuby instances of puppetserver

## v1.0.0 - 2017-07-03
### Added
- Initial releas
