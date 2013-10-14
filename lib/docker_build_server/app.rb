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
    helpers DockerBuildServer::Helpers::JSON
    helpers DockerBuildServer::Helpers::Travis

    set :root, File.expand_path('../', __FILE__)
    set :views, "#{settings.root}/views"
    set :public_dir, "#{settings.root}/public"
    set :travis_authenticators, Rack::Auth::Travis.default_authenticators

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

    enable :sessions

    get '/' do
      redirect 'index.html', 301
    end

    get '/index.html', provides: [:html, :json] do
      respond_to do |f|
        f.html { erb :index }
        f.json { json nobody: :home }
      end
    end

    post '/docker-build' do
      build_params = params.to_hash
      build_params = json_body if json?

      respond_to do |f|
        f.html do
          build_response = docker_build(build_params)
          session['flash'] = build_response['message']
          redirect 'index.html', 301
        end
        f.json do
          build_response = docker_build(build_params)
          status 201
          json build_response
        end
      end
    end

    post ENV['TRAVIS_WEBHOOK_PATH'] || '/travis-webhook' do
      halt 401 unless travis_authorized?
      halt 400 unless travis_payload

      halt 204 if travis_docker_build_disabled?

      build_response = docker_build(travis_build_params)
      status 201
      json build_response
    end

    def docker_build(params)
      build_params = BuildParams.new(params.to_hash)
      halt 400 unless build_params.valid?

      DockerBuild.perform_async(build_params.to_hash)

      build_params.to_hash.merge(
        'message' => "Building #{params['repo'].inspect} " <<
        "at #{params['ref'].inspect}"
      )
    end

    def title
      @title ||= (ENV['DOCKER_BUILD_SERVER_TITLE'] || 'docker build server')
    end
  end
end
