FROM quay.io/modcloth/ruby2-dev:latest
MAINTAINER Dan Buch <d.buch@modcloth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get -yq update && \
    apt-get -yq install curl git && \
    echo 'gem: --no-ri --no-rdoc' > ~/.gemrc && \
    /bin/bash -l -c 'rvm use 2.0.0 --default' && \
    gem install bundler foreman
ADD . /docker-build-server
RUN cd /docker-build-server && \
    bundle install && \
    bundle install --deployment

EXPOSE 8080

CMD ["/docker-build-server/runapp"]
