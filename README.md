# docker-build-server

This is a sinatra app that's meant to act as a companion to
[docker-build-worker](https://github.com/modcloth-labs/docker-build-worker).

Docker build "jobs" may be created by `POST`'ing to `/docker-build` with json or
form-encoded params.  There is a simple html form included at `/index.html`.

Travis webhook payloads are also supported, by default at `POST /travis-webook`.
See the Travis webhook section below for more details.

## Installation

``` bash
gem install docker-build-server
```

## Usage

Run via the `rackup` wrapper script:

``` bash
docker-build-server --help
```

Or do whatever you want inside a `config.ru`:

``` ruby
# config.ru
require 'docker-build-server'

run DockerBuildServer.app
```

### Travis webhooks

You can send Travis webhook notifications to a `docker-build-server` instance to
automatically build and push containers upon successful completion of Travis
builds.  An example `.travis.yml` might look like this (note the use of
`$TRAVIS_COMMIT`, which is explicitly substituted):

``` yaml
---
# language-specific bits up here...
docker_build:
  tag: myaccount/myproject:$TRAVIS_COMMIT
  auto_push: true
notifications:
  webhooks:
    urls:
    - https://docker-build-server.example.com/travis-webhook
    on_success: always
    on_failure: never
```

In addition to `$TRAVIS_COMMIT`, `$TRAVIS_SHORT_COMMIT` and `$TRAVIS_BRANCH`
will also be replaced in the `tag` key.

You may notice that in this case the webhook URL does not contain basic auth.
This is because the Travis webhook route may be configured to use
[rack-auth-travis](https://github.com/modcloth-labs/rack-auth-travis) to
authenticate requests from Travis-CI by setting `AUTH_TYPE='travis'`.  Doing so
also requires the `docker-build-server` is run with the necessary
`TRAVIS_AUTH_*` environmental variables present.

Alternatively, basic authentication may be used by setting `AUTH_TYPE='basic'`
and providing `BASIC_AUTHZ='user:pass user:pass'`, which should be
whitespace-delimited `username:password` pairs.  The values for `username` and
`password` may be url-encoded in order to include whitespace and colons.
