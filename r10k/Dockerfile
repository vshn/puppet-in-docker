FROM ubuntu:20.04

ARG PUPPET_AGENT_VERSION="6.23.0"
ENV R10K_VERSION="3.9.3" \
    DUMB_INIT_VERSION="1.2.2" \
    UBUNTU_CODENAME="focal" \
    PUPPET_MODULE_CHORIA_VERSION="0.24.0" \
    PUPPET_MODULE_MCOLLECTIVE_CHORIA_VERSION="0.21.0" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_PUPPET_VERSION="2.4.1" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_SERVICE_VERSION="4.0.1" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_PACKAGE_VERSION="5.3.0" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_FILEMGR_VERSION="2.0.1" \
    PUPPET_MODULE_MCOLLECTIVE_UTIL_ACTIONPOLICY_VERSION="3.2.0" \
    PUPPET_MODULE_R10K_VERSION="10.0.0" \
    GWS_VERSION="0.2.0" \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet r10k" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$PUPPET_SERVER_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["r10k" ]

COPY Dockerfile /

# TODO checksum check
RUN apt-get update && \
    apt-get install -y wget git netcat lsb-release cron vim && \
    wget https://apt.puppetlabs.com/puppet6-release-"${UBUNTU_CODENAME}".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"${DUMB_INIT_VERSION}"_amd64.deb && \
    wget https://github.com/StreakyCobra/gws/releases/download/"${GWS_VERSION}"/gws-"${GWS_VERSION}" -O /usr/local/bin/gws && \
    chmod +x /usr/local/bin/gws && \
    dpkg -i puppet6-release-"${UBUNTU_CODENAME}".deb && \
    dpkg -i dumb-init_"${DUMB_INIT_VERSION}"_amd64.deb && \
    rm puppet6-release-"${UBUNTU_CODENAME}".deb dumb-init_"${DUMB_INIT_VERSION}"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent="${PUPPET_AGENT_VERSION}"-1"${UBUNTU_CODENAME}" && \
    gem install r10k --version "${R10K_VERSION}" --no-ri --no-rdoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install and configure MCollective using Choria from R.I.Pienaar
# Install r10k
RUN puppet module install choria-choria --version "${PUPPET_MODULE_CHORIA_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_choria --version "${PUPPET_MODULE_MCOLLECTIVE_CHORIA_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_puppet --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_PUPPET_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_service --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_SERVICE_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_package --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_PACKAGE_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_filemgr --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_FILEMGR_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_util_actionpolicy --version "${PUPPET_MODULE_MCOLLECTIVE_UTIL_ACTIONPOLICY_VERSION}" --target-dir /tmp/modules && \
    puppet module install puppet-r10k --version "${PUPPET_MODULE_R10K_VERSION}" --target-dir /tmp/modules
COPY build/hiera.yaml build/common.yaml build/main.pp /tmp/
RUN apt-get update && puppet apply --hiera_config=/tmp/hiera.yaml --modulepath=/tmp/modules /tmp/main.pp && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure .ssh directory
RUN mkdir /root/.ssh \
  && chmod 0600 /root/.ssh \
  && echo StrictHostKeyChecking no > /root/.ssh/config

# Add configuration file into the image
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
COPY request-cert.rb /usr/local/bin
COPY agent/git.ddl agent/git.rb /opt/puppetlabs/mcollective/plugins/mcollective/agent/
COPY agent/r10kcli.ddl agent/r10kcli.rb /opt/puppetlabs/mcollective/plugins/mcollective/agent/

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
