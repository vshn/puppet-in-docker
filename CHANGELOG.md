# Changelog
Please document all notable changes to this project in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased
### Changed
- puppetserver and puppetdb Dockerfile can now build other versions via build-args

### Removed
- Support for lagacy PuppetDB API
- Puppet 4 Server Dockerfile

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
