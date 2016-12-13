FROM ubuntu:16.04

ENV PUPPET_AGENT_VERSION="1.8.0" \
    R10K_VERSION="2.4.3" \
    DUMB_INIT_VERSION="1.2.0" \
    UBUNTU_CODENAME="xenial" \
    PUPPET_MODULE_MCOLLECTIVE_VERSION="0.0.21" \
    PUPPET_MODULE_R10K_VERSION="4.0.2" \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

LABEL org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppet-in-docker" \
      org.label-schema.name="Puppet r10k" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version=$PUPPET_SERVER_VERSION \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppet-in-docker" \
      org.label-schema.vcs-ref="791b5505348e901a21b2ca2700068e2743019848" \
      org.label-schema.build-date="2016-09-14T13:37:00Z" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["r10k" ]

COPY Dockerfile /

# TODO checksum check
RUN apt-get update && \
    apt-get install -y wget git netcat && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-"$UBUNTU_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppetlabs-release-pc1-"$UBUNTU_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    rm puppetlabs-release-pc1-"$UBUNTU_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent="$PUPPET_AGENT_VERSION"-1"$UBUNTU_CODENAME" && \
    gem install r10k --version $R10K_VERSION --no-ri --no-rdoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install and configure MCollective using Choria from R.I.Pienaar
# Install r10k
RUN puppet module install ripienaar-mcollective --version "$PUPPET_MODULE_MCOLLECTIVE_VERSION" --target-dir /tmp/modules && \
    puppet module install puppet-r10k --version "$PUPPET_MODULE_R10K_VERSION" --target-dir /tmp/modules
COPY build/hiera.yaml build/common.yaml build/main.pp /tmp/
RUN apt-get update && puppet apply --hiera_config=/tmp/hiera.yaml --modulepath=/tmp/modules /tmp/main.pp && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure .ssh directory
RUN mkdir /root/.ssh \
  && chmod 0600 /root/.ssh \
  && echo StrictHostKeyChecking no > /root/.ssh/config

# Add configuration file into the image
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ONBUILD COPY /docker-entrypoint.d/* /docker-entrypoint.d/

