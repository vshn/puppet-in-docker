FROM haproxy:1.7-alpine

ENV DUMB_INIT_VERSION="1.2.2" \
    CONFD_VERSION="0.16.0"

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet HAProxy" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

EXPOSE 8140

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["haproxy"]

COPY Dockerfile /

# TODO checksum check
RUN apk add --no-cache \
      run-parts \
      ruby \
      curl \
      ca-certificates \
      wget \
      openssl \
      openssl-dev \
      ruby-dev \
      alpine-sdk \
      netcat-openbsd \
      bash && \
      gem install --no-rdoc --no-ri openssl && \
      update-ca-certificates && \
      wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64 && \
      wget -O /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v"$CONFD_VERSION"/confd-"$CONFD_VERSION"-linux-amd64 && \
      chmod +x /usr/local/bin/dumb-init /usr/local/bin/confd && \
      mkdir -p /etc/confd/conf.d /etc/confd/templates && \
      adduser -h /usr/local/etc/haproxy -s /bin/sh -S -D -H haproxy && \
      mkdir /usr/local/etc/haproxy/ssl && \
      chown -R haproxy /usr/local/etc/haproxy

# Add configuration files into the image
COPY request-cert.rb /usr/local/bin
COPY haproxy.tmpl /etc/confd/templates
COPY haproxy.toml /etc/confd/conf.d

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
