# vim:fileencoding=utf-8
require 'multi_json'
require 'rack-auth-travis'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/json'
require_relative '../docker_build'
require_relative 'build_params'
require_relative 'helpers'

module DockerBuildServer
  class App < Sinatra::Base
    register Sinatra::Contrib
    helpers Sinatra::JSON
    helpers DockerBuildServer::Helpers::All

    set :root, File.expand_path('../', __FILE__)
    set :views, "#{settings.root}/views"
    set :public_dir, "#{settings.root}/public"

    set :travis_authenticators, Rack::Auth::Travis.default_authenticators
    set(:travis_auth_disabled) { ENV['AUTH_TYPE'] != 'travis' }

    set(:logging) { !ENV['DISABLE_LOGGING'] }
    set(:log_level_string) { (ENV['LOG_LEVEL'] || 'info').upcase }
    set(:log_level) { Logger.const_get(settings.log_level_string) }

    enable :sessions

    configure :development do
      set :session_secret, 'shotgun-hack-hack-hack'
      enable :logging, :dump_errors, :raise_errors, :show_exceptions
    end

    Sidekiq.configure_client do |config|
      config.redis = {
        url: ENV['REDIS_URL'] || 'redis://localhost:6379/',
        namespace: (
          ENV['REDIS_NAMESPACE'] || 'docker-build-server'
        ).sub(/:$/, '')
      }
    end

    before do
      logger.level = settings.log_level if settings.logging?
      logger.debug { "log_level #{settings.log_level_string.inspect}" }
      headers 'Docker-Build-Server-Version' => (
        ENV['VERSION'] || DockerBuildServer.full_version
      )
    end

    get('/') { redirect 'index.html', 301 }

    get '/index.html', provides: [:html, :json] do
      respond_to do |f|
        f.html { erb :index }
        f.json { json nobody: :home }
      end
    end

    post '/docker-build' do
      build_params = params.to_hash
      build_params = json_body if json?
      logger.debug { "build_params=#{build_params.inspect}" }

      # errors = validate_build_params(build_params)
      errors = []
      unless errors.empty?
        respond_to do |f|
          f.html do
            session['errors'] = errors
            status 400
            erb :index
          end
          f.json do
            status 400
            json errors: errors
          end
        end && return
      end

      respond_to do |f|
        f.html do
          build_response = docker_build(build_params)
          logger.debug { "build_response=#{build_response.inspect}" }

          session['flash'] = build_response['message']
          redirect 'index.html', 301
        end
        f.json do
          build_response = docker_build(build_params)
          logger.debug { "build_response=#{build_response.inspect}" }

          status 201
          json build_response
        end
      end
    end

    post ENV['TRAVIS_WEBHOOK_PATH'] || '/travis-webhook' do
      logger.debug do
        request.body.rewind
        %W(
          authorization=#{request.env['HTTP_AUTHORIZATION'].inspect}
          travis_repo_slug=#{request.env['HTTP_TRAVIS_REPO_SLUG'].inspect}
          travis_authorized?=#{travis_authorized?.inspect}
          request.body=#{request.body.read.inspect}
        ).join(' ')
      end
      request.body.rewind

      halt 401 unless settings.travis_auth_disabled? || travis_authorized?
      halt 400 unless travis_payload

      halt 204 if travis_docker_build_disabled?

      logger.debug { "travis_payload=#{travis_payload.inspect}" }
      logger.debug { "travis_build_params=#{travis_build_params.inspect}" }

      build_response = docker_build(travis_build_params)

      logger.debug { "build_response=#{build_response.inspect}" }

      status 201
      json build_response
    end
  end
end
