FROM ubuntu:18.04

# You can build different variants using docker build -t vshn/puppet-puppetserver:7.0 --build-arg "PUPPET_SERVER_VERSION=7.0.0" --build-arg "PUPPETDB_TERMINI_VERSION=7.0.0"
ARG PUPPET_SERVER_VERSION="6.16.0"
ARG PUPPETDB_TERMINI_VERSION="6.16.1"
ARG PUPPET_AGENT_VERSION=""

ENV DUMB_INIT_VERSION="1.2.2" \
    UBUNTU_CODENAME="bionic" \
    PUPPETSERVER_JAVA_ARGS="-Xms256m -Xmx256m" \
    PUPPETSERVER_JRUBYINSTANCES=2 \
    LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8 \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet Server" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$PUPPET_SERVER_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

EXPOSE 8140

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["puppetserver"]

COPY Dockerfile /

# TODO checksum check
RUN apt-get update && apt-get -y install gnupg && \
    echo "deb http://ppa.launchpad.net/vshn/puppetserver-tools/ubuntu bionic main" > /etc/apt/sources.list.d/vshn-ubuntu-puppetserver-tools-bionic.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 90A6F6E5A19FC22CED8BFAD73EB114CF19617013 && \
    apt-get update && \
    apt-get install -y wget git netcat vim locales enc python3 && \
    locale-gen en_US.UTF-8
RUN major_version=$(echo "${PUPPET_SERVER_VERSION}" | cut -d. -f1) && \
    wget https://apt.puppetlabs.com/puppet"$major_version"-release-"$UBUNTU_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppet"$major_version"-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    rm puppet"$major_version"-release-"$UBUNTU_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb

# We need a matching puppet-agent version for puppetserver 6, otherwise there can be missing ruby dependencies
RUN ["/bin/bash", "-c", "if [ ! -z ${PUPPET_AGENT_VERSION} ]; then apt-get install --no-install-recommends -y puppet-agent=${PUPPET_AGENT_VERSION}-1${UBUNTU_CODENAME}; fi"]

# Install puppetserver and puppetdb-termini
RUN apt-get install --no-install-recommends -y puppetserver="$PUPPET_SERVER_VERSION"-1"$UBUNTU_CODENAME" puppetdb-termini="$PUPPETDB_TERMINI_VERSION"-1"$UBUNTU_CODENAME" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    find \
      /etc/puppetlabs \
      /opt/puppetlabs/server/data/puppetserver \
      -exec chgrp -R root {} + \
      -exec chown -R puppet {} + \
      -exec chmod -R g=rwX,g-s {} +

# Add configuration files into the image
COPY config/puppetserver /etc/default/puppetserver
COPY config/logback.xml /etc/puppetlabs/puppetserver/
COPY config/request-logging.xml /etc/puppetlabs/puppetserver/
COPY config/puppetdb.conf /etc/puppetlabs/puppet/
COPY config/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
COPY config/auth.conf /etc/puppetlabs/puppetserver/conf.d/auth.conf

# Add scripts to get started easily
COPY config/simple-enc /etc/puppetlabs/puppet/simple-enc
COPY config/simple-autosign /etc/puppetlabs/puppet/simple-autosign
COPY request-cert.rb /usr/local/bin

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

# Because of how Puppetserver is started (bash -> su)
# this currently doesn't work
#USER puppet
