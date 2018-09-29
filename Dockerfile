FROM ubuntu:16.04

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
      && apt-get install -y wget nodejs npm ntp git\
      && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/nodejs /usr/bin/node

WORKDIR "/opt"
RUN git clone https://github.com/cubedro/eth-net-intelligence-api.git
RUN git clone https://github.com/cubedro/eth-netstats.git

# install backend. Talks to the geth-docker
# via the RPC interface defined in app.json
WORKDIR "/opt/eth-net-intelligence-api"
RUN npm install -g pm2
ADD ./app.json ./app.json
RUN npm install

# install frontend
WORKDIR "/opt/eth-netstats"
RUN npm install
RUN npm install -g grunt-cli
RUN grunt

# Get the entrypoint script and make sure it is executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

# This is run each time the container is started
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
