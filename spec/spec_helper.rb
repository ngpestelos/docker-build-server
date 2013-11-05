# vim:fileencoding=utf-8
require 'simplecov'
require 'docker-build-server'

require 'fakeredis'
require 'rack/test'
require 'sidekiq'

require_relative 'support'

redis_opts = {
  url: 'redis://127.0.0.1:6379/1',
  driver: Redis::Connection::Memory
}

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end
