# vim:fileencoding=utf-8
require './lib/docker-build-server'
require 'sidekiq/web'

map('/') { run DockerBuildServer.new }
map('/sidekiq') { run Sidekiq::Web }
