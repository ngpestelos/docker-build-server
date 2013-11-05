FROM quay.io/modcloth/ruby2-dev:latest
MAINTAINER Dan Buch <d.buch@modcloth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN cd / && \
    curl -s -L https://s3.amazonaws.com/modcloth-public-travis-artifacts/artifacts/ruby/$(uname -s | tr '[:upper:]' '[:lower:]')/$(uname -m)/docker-build-server/master/docker-build-server.tar.bz2 | tar -xjvf - && \
    echo 'gem: --no-ri --no-rdoc' > ~/.gemrc && \
    bash -l -c 'rvm use 2.0.0 --default' && \
    gem install bundler

EXPOSE 8080

CMD ["/docker-build-server/runapp"]
