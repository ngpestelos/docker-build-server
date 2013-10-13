# vim:fileencoding=utf-8
require './lib/docker-build-server'
require 'rack/urlmap'
require 'rack-auth-travis'
require 'sidekiq/web'

dbs = DockerBuildServer.new
run Rack::URLMap.new(
  '/' => dbs,
  '/travis' => Rack::Auth::Travis.new(dbs, realm: 'docker-build-server'),
  '/sidekiq' => Sidekiq::Web.new
)
