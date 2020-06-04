FROM alpine:3.6

ARG NATS_VERSION="0.9.6"
ENV DUMB_INIT_VERSION="1.2.2"

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet Choria NATS Broker" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$NATS_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

# 4222: Client access port
# 6222: Cluster port
# 8222: Management port
EXPOSE 4222 6222 8222

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["nats"]

COPY Dockerfile /

# TODO checksum check
RUN apk add --no-cache \
      run-parts \
      ruby \
      curl \
      ca-certificates \
      wget \
      openssl \
      netcat-openbsd \
      unzip \
      bash && \
      update-ca-certificates && \
      wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64 && \
      wget -O /tmp/nats-server.zip https://github.com/nats-io/nats-server/releases/download/v"$NATS_VERSION"/nats-server-v"$NATS_VERSION"-linux-amd64.zip && \
      unzip /tmp/nats-server.zip -d /tmp && mv /tmp/nats-server-v"$NATS_VERSION"-linux-amd64/nats-server /usr/local/bin/nats-server && \
      rm -rf /tmp/nats-server.zip /tmp/nats-server-v"$NATS_VERSION"-linux-amd64/ && \
      chmod +x /usr/local/bin/dumb-init /usr/local/bin/nats-server&& \
      adduser -h /etc/nats -s /bin/sh -S -D -H nats && \
      mkdir /etc/nats && \
      chown -R nats /etc/nats

# Add configuration files into the image
COPY request-cert.rb /usr/local/bin
COPY nats.cfg /etc/nats/nats-server.conf

COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

