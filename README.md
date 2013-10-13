# docker-build-server

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
