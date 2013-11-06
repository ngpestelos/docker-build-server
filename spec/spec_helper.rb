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

ENV['LOG_LEVEL'] = 'debug'
ENV['AUTH_TYPE'] = 'basic'
ENV['BASIC_AUTH_REALM'] = 'RSpec Land!'
ENV['BASIC_AUTHZ'] = 'fizz:buzz ham:bone'
