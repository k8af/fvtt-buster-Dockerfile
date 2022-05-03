# Another flat Docker build file to create image of debian 10 linux system for Foundry VTT.
# Use this file to test or create your own docker images for free.
# You can do that on your home server or on a vps instance.
# 
# Dockerfile v1.0 - MIT License

# ---------------------------------------------------------------------------------------------------------
# This file requires you to possess root permissions otherwise, you’ll receive a “permission denied” error. 
# Be sure to login to the root account or just prepend sudo to your commands
# ---------------------------------------------------------------------------------------------------------

FROM debian:10-slim
#RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list


LABEL maintainer="info@wuerfelfeste.de"

RUN echo 'deb http://httpredir.debian.org/debian buster main non-free contrib' > /etc/apt/sources.list
RUN echo 'deb-src http://httpredir.debian.org/debian buster main non-free contrib' >> /etc/apt/sources.list
RUN echo 'deb http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list

#RUN echo '127.0.1.1 rproxy.etabliocity.local rptoxy' >> /etc/hosts
RUN echo '172.23.3.1 rproxy.etabliocity.local rproxy' >> /etc/hosts
RUN echo '172.23.3.2 vtt.etabliocity.local fvtt' >> /etc/hosts

# Create the foundry install home
RUN mkdir -p /srv/foundry/fvtt
RUN mkdir -p /srv/foundry/data
RUN mkdir -p /srv/foundry/xfer

# Create user with install home and unlimited expiring password
RUN useradd -d /srv/foundry -K PASS_MAX_DAYS=-1 foundry

# Setup permissions for install home
RUN chown -R foundry. /srv/foundry/

# Set environmental variables (use ARG for nonpersistent vars after building)
ARG FOUNDRY_HOME=/srv/foundry/fvtt/
ARG FOUNDRY_DATA=/srv/foundry/data
ARG FOUNDRY_TEMP=/srv/foundry/xfer/
ARG FOUNDRY_HOST_IMPORT=xfer/
ARG FVTTPORT=30000

## for apt to be noninteractive
ARG DEBIAN_FRONTEND noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN true


# Installs locales
RUN apt update -y
RUN apt upgrade -y
RUN apt-get install -y locales 

## preesed tzdata, update package index, upgrade packages and install needed software
RUN truncate -s0 /tmp/preseed.cfg; \
    echo "tzdata tzdata/Areas select Europe" >> /tmp/preseed.cfg; \
    echo "tzdata tzdata/Zones/Europe select Berlin" >> /tmp/preseed.cfg; \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata

# Installs the latest packages version for debian
RUN apt-get install -y gcc g++ make tree curl vim-nox ufw rsync iputils-ping procps

# Installs the latest nodejs version for debian
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && apt-get install -y nodejs

# Set the current working directory
WORKDIR "${FOUNDRY_HOME}"

# Copy foundry from HOST into Container WORKDIR
COPY "${FOUNDRY_HOST_IMPORT}" "${FOUNDRY_TEMP}"

# Update Foundry with latest HOST_IMPORT
RUN rsync -h --progress --stats -r -tgo -p -l -D --update "${FOUNDRY_TEMP}" .

# Setup permissions for install home
RUN chown -R foundry. /srv/foundry/

EXPOSE "${FVTTPORT}"
RUN echo "----> building foundry vtt docker image..... done."
RUN echo "----> Starting Foundry VTT."
RUN ls -la .
#CMD node ${FOUNDRY_HOME}/resources/app/main.js --dataPath=${FOUNDRY_DATA}

