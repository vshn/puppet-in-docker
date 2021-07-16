FROM ubuntu:20.04

ARG PUPPET_AGENT_VERSION="6.23.0"
ENV DUMB_INIT_VERSION="1.2.2" \
    UBUNTU_CODENAME="focal" \
    PUPPET_MODULE_CHORIA_VERSION="0.24.0" \
    PUPPET_MODULE_MCOLLECTIVE_CHORIA_VERSION="0.21.0" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_PUPPET_VERSION="2.4.1" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_SERVICE_VERSION="4.0.1" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_PACKAGE_VERSION="5.3.0" \
    PUPPET_MODULE_MCOLLECTIVE_AGENT_FILEMGR_VERSION="2.0.1" \
    PUPPET_MODULE_MCOLLECTIVE_UTIL_ACTIONPOLICY_VERSION="3.2.0" \
    PUPPET_MODULE_R10K_VERSION="10.0.0" \
    MCO_CLIENT_USER="deployer" \
    PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet Code Deployer" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$PUPPET_SERVER_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]

# TODO checksum check
RUN apt-get update && \
    apt-get install -y wget git netcat lsb-release cron vim && \
    wget https://apt.puppetlabs.com/puppet6-release-"${UBUNTU_CODENAME}".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"${DUMB_INIT_VERSION}"/dumb-init_"${DUMB_INIT_VERSION}"_amd64.deb && \
    dpkg -i puppet6-release-"${UBUNTU_CODENAME}".deb && \
    dpkg -i dumb-init_"${DUMB_INIT_VERSION}"_amd64.deb && \
    rm puppet6-release-"${UBUNTU_CODENAME}".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent="${PUPPET_AGENT_VERSION}"-1"${UBUNTU_CODENAME}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --disabled-password --gecos "" "${MCO_CLIENT_USER}"

# Install and configure MCollective using Choria from R.I.Pienaar
RUN puppet module install choria-choria --version "${PUPPET_MODULE_CHORIA_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_choria --version "${PUPPET_MODULE_MCOLLECTIVE_CHORIA_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_puppet --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_PUPPET_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_service --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_SERVICE_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_package --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_PACKAGE_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_agent_filemgr --version "${PUPPET_MODULE_MCOLLECTIVE_AGENT_FILEMGR_VERSION}" --target-dir /tmp/modules && \
    puppet module install choria-mcollective_util_actionpolicy --version "${PUPPET_MODULE_MCOLLECTIVE_UTIL_ACTIONPOLICY_VERSION}" --target-dir /tmp/modules
COPY build/hiera.yaml build/common.yaml build/main.pp /tmp/
RUN apt-get update && puppet apply --hiera_config=/tmp/hiera.yaml --modulepath=/tmp/modules /tmp/main.pp && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chown -R $MCO_CLIENT_USER /etc/choria/

# Add configuration file into the image
COPY agent/git.ddl /opt/puppetlabs/mcollective/plugins/mcollective/agent/
COPY agent/r10kcli.ddl /opt/puppetlabs/mcollective/plugins/mcollective/agent/

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

COPY Dockerfile /

USER $MCO_CLIENT_USER
WORKDIR /home/$MCO_CLIENT_USER
