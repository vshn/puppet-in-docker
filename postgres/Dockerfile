FROM postgres:9.6

LABEL org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="PostgreSQL instance for PuppetDB" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="0.1.0" \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.vcs-ref="master" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

COPY Dockerfile /
