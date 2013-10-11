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
  git-core \
  libxml2-dev \
  libxslt1-dev \
  mercurial \
  redis-server \
  vim-nox

ln -svf /vagrant/.vagrant-skel/redis.conf /etc/redis/redis.conf
service redis-server restart

if which docker ; then
  initctl stop dockerd || true
fi

if ! getent group docker ; then
  groupadd docker
fi

if [ -z "$(getent group docker | grep vagrant)" ] ; then
  usermod -a -G docker vagrant
fi

curl -s https://get.docker.io | sh
set +e
initctl stop dockerd
initctl start dockerd
set -e
t=0
while [ $t -lt 20 ] ; do
  if [ -e /var/run/docker.sock ] ; then
    t=20
  else
    echo -en '.'
    sleep 0.5
    let t+=1
  fi
done
chown root:docker /var/run/docker.sock || true

su - vagrant -c bash <<EOBASH
#!/bin/bash
set -x
set -e

ln -svf /vagrant/.vagrant-skel/bashrc /home/vagrant/.bashrc
ln -svf /vagrant/.vagrant-skel/profile /home/vagrant/.profile
rm -vf /home/vagrant/.bash_profile

set +e
source ~/.profile
if ! which gvm >/dev/null ; then
  set +x
  bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
  set -x
fi
source ~/.profile
gvm get
if [ -z "\$(gvm list | grep go1.1.2)" ] ; then
  gvm install go1.1.2
fi
set -e
gvm use go1.1.2
mkdir -p \${GOPATH%%:*}/src
pushd \${GOPATH%%:*}/src
if [ -f /docker-build-worker/Makefile ] ; then
  if [ -e ./dbw ] ; then
    rm -rvf ./dbw
  fi
  ln -svf /docker-build-worker ./dbw
else
  if [ ! -d dbw ] ; then
    git clone https://github.com/modcloth-labs/docker-build-worker.git dbw
  else
    pushd dbw
    git fetch --all
    git checkout -qf master
    popd
  fi
fi
pushd dbw
make build

curl -L https://get.rvm.io | bash -s stable --ruby=2.0.0
source ~/.bash_profile
gem install bundler foreman

mkdir -p ~/.ssh
chmod 0700 ~/.ssh
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
EOBASH
echo 'Ding!'
