# vim:fileencoding=utf-8
require 'multi_json'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/json'
require_relative 'docker_build'
require_relative 'docker_build_params'

class DockerBuildServer < Sinatra::Base
  VERSION = '0.1.0' unless defined?(VERSION)
  register Sinatra::Contrib
  helpers Sinatra::JSON

  set :root, File.expand_path('../', __FILE__)
  set :views, "#{settings.root}/docker_build_server/views"
  set :public_dir, "#{settings.root}/docker_build_server/public"

  configure :development do
    set :session_secret, 'brzzzt'
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

  helpers do
    def json_body
      ::MultiJson.decode(request.body)
    end
  end

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
    build_params = json_body if request.content_type =~ /application\/json/i

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

  def docker_build(params)
    build_params = DockerBuildParams.new(params.to_hash)
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
