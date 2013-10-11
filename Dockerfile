FROM ubuntu:12.04
MAINTAINER Dan Buch <d.buch@modcloth.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -yq update
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install curl git-core libxml2-dev libxslt1-dev
RUN curl -L https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm install 2.0.0-p247
ENV PATH /usr/local/rvm/wrappers/ruby-2.0.0-p247:/usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c 'rvm use 2.0.0 --default'
RUN gem install --no-ri --no-rdoc bundler foreman
ADD . /docker-build-server
RUN cd /docker-build-server && bundle install --deployment

EXPOSE 8080

CMD ["/docker-build-server/runapp"]
