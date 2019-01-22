FROM ubuntu:18.04

ARG PUPPETDB_VERSION="5.2.7"

ENV DUMB_INIT_VERSION="1.2.2" \
    UBUNTU_CODENAME="bionic" \
    PUPPETDB_USER=puppetdb \
    PUPPETDB_PASSWORD=puppetdb \
    PUPPETDB_JAVA_ARGS="-Djava.net.preferIPv4Stack=true -Xms256m -Xmx256m" \
    PUPPETDB_NODETTL="30d" \
    PUPPETDB_MAXPOOLSIZE=25 \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="PuppetDB" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$PUPPETDB_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

EXPOSE 8080 8081

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["puppetdb"]

COPY Dockerfile /

# TODO checksum check
RUN apt-get update && \
    apt-get install -y wget netcat curl vim ruby && \
    major_version=$(echo "${PUPPETDB_VERSION}" | cut -d. -f1) && \
    wget https://apt.puppetlabs.com/puppet"$major_version"-release-"$UBUNTU_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppet"$major_version"-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    rm puppet"$major_version"-release-"$UBUNTU_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppetdb="$PUPPETDB_VERSION"-1"$UBUNTU_CODENAME" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add configuration files into the image
COPY puppetdb /etc/default/
COPY logging /etc/puppetlabs/puppetdb/logging
COPY request-cert.rb /usr/local/bin
RUN rm -rf /etc/puppetlabs/puppetdb/conf.d
COPY conf.d /etc/puppetlabs/puppetdb/conf.d

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
