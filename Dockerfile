FROM google/cloud-sdk:slim

RUN \
      apt-get update && \
      apt-get -qqy install --fix-missing \
            wget \
      && \
      apt-get clean

# Install jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  mv jq-linux64 /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq

ADD assets/ /opt/resource/
