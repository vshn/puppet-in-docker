FROM nginx:alpine

ENV PUPPET_EXPLORER_VERSION="2.0.0" \
    DUMB_INIT_VERSION="1.2.1"

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppetexplorer" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$PUPPET_EXPLORER_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

EXPOSE 8080

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["nginx"]

COPY Dockerfile /

# TODO checksum check
RUN apk add --no-cache \
      ca-certificates \
      wget \
      run-parts \
      bash && \
      update-ca-certificates && \
      wget https://github.com/spotify/puppetexplorer/releases/download/"$PUPPET_EXPLORER_VERSION"/puppetexplorer-"$PUPPET_EXPLORER_VERSION".tar.gz -O - | tar -xz && \
      wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64 && \
      chmod +x /usr/local/bin/dumb-init && \
      ln -s puppetexplorer-"$PUPPET_EXPLORER_VERSION" /puppetexplorer

# This patch fixes https://github.com/spotify/puppetexplorer/issues/56 until a new release of puppetexplorer is made
RUN sed -i -e 's/puppetlabs\.puppetdb\.query\.population/puppetlabs\.puppetdb\.population/g' -e 's/type=default,//g' /puppetexplorer/app.js

# Add configuration files into the image
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.js /puppetexplorer

# Copy entrypoint into container
COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

