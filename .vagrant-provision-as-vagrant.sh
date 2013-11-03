#!/bin/bash
set -x
set -e

ln -svf /vagrant/.vagrant-skel/bashrc /home/vagrant/.bashrc
ln -svf /vagrant/.vagrant-skel/bash_profile /home/vagrant/.bash_profile
ln -svf /vagrant/.vagrant-skel/gemrc /home/vagrant/.gemrc

mkdir -p ~/.ssh
chmod 0700 ~/.ssh
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

set +e
source ~/.bash_profile
if ! which gvm >/dev/null ; then
  set +x
  bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
  set -x
fi
source ~/.bash_profile
gvm get
if [ -z "$(gvm list | grep go1.1.2)" ] ; then
  gvm install go1.1.2
fi
set -e

set +x
gvm use go1.1.2
set -x

mkdir -p ${GOPATH%%:*}/src/github.com/modcloth-labs
pushd ${GOPATH%%:*}/src/github.com/modcloth-labs
if [ ! -f /docker-build-worker/Makefile ] ; then
  if [ ! -d github.com/modcloth-labs/docker-build-worker ] ; then
    git clone https://github.com/modcloth-labs/docker-build-worker.git \
              github.com/modcloth-labs/docker-build-worker
  fi
  pushd github.com/modcloth-labs/docker-build-worker
  git fetch --all
  git checkout -qf master
else
  pushd /docker-build-worker
fi
make build

pushd /vagrant

set +x
curl -L https://get.rvm.io | bash -s stable --ruby=2.0.0 --auto-dotfiles
source ~/.bash_profile || true
gem install bundler foreman
