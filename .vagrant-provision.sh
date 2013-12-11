#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e
set -x

apt-get update -yq
apt-get install -yq \
  curl \
  python-software-properties
apt-add-repository -y ppa:chris-lea/redis-server
apt-get update -yq
apt-get install -yq \
  bison \
  build-essential \
  git \
  mercurial \
  redis-server \
  screen \
  vim-nox

ln -svf /vagrant/.vagrant-skel/redis.conf /etc/redis/redis.conf
service redis-server restart

if ! getent group docker ; then
  groupadd docker
fi

if [ -z "$(getent group docker | grep vagrant)" ] ; then
  usermod -a -G docker vagrant
fi

chown root:docker /var/run/docker.sock || true

su - vagrant -c /vagrant/.vagrant-provision-as-vagrant.sh
echo 'Ding!'
