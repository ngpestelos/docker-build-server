# vim:fileencoding=utf-8
require './lib/docker-build-server'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

run Sidekiq::Web
run DockerBuildServer::Builder.app
