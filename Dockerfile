FROM ubuntu:12.04
MAINTAINER Dan Buch <d.buch@modcloth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/rvm/wrappers/ruby-2.0.0-p247:/usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get -yq update && \
    apt-get -yq install curl git-core libxml2-dev libxslt1-dev && \
    curl -L https://get.rvm.io | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.0.0-p247 && \
    /bin/bash -l -c 'rvm use 2.0.0 --default' && \
    echo 'gem: --no-ri --no-rdoc' > ~/.gemrc && \
    gem install bundler foreman
ADD . /docker-build-server
RUN cd /docker-build-server && \
    bundle install && \
    bundle install --deployment

EXPOSE 8080

CMD ["/docker-build-server/runapp"]
