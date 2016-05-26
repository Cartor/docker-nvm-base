FROM ubuntu:14.04.4
MAINTAINER Cartor Chen <cartor@gmail.com>

# setup base system
COPY apt.sources.list /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy build-essential libssl-dev git man curl

USER root

# Declare constants
ENV NVM_VERSION v0.31.1
ENV NODE_VERSION 0.12.14

ENV NVM_DIR /usr/local/nvm

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default $NODE_VERSION

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install app dependencies
RUN npm install -g gulp && npm install -g pm2

WORKDIR /workspace
EXPOSE  3000

ENTRYPOINT ["/bin/bash", "--login", "-i", "-c"]
CMD ["bash"]
