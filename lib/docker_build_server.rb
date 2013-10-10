# vim:fileencoding=utf-8
require 'json'
require 'sinatra/base'
require 'sinatra/contrib'

class DockerBuildServer < Sinatra::Base
  VERSION = '0.1.0'
  register Sinatra::Contrib

  enable :sessions
  set :views, File.expand_path('../docker_build_server/views', __FILE__)
  configure(:development) { set :session_secret, 'brzzzt' }

  get '/' do
    status 301
    headers 'Location' => '/index.html'
  end

  get '/index.html', provides: [:html, :json] do
    respond_to do |f|
      f.html { erb :index }
      f.json { JSON.pretty_generate({ nobody: :home }) }
    end
  end

  post '/docker-build' do
    build_response = {
      'message' => "Building #{params[:repo].inspect} " <<
                   "at #{params[:ref].inspect}"
    }
    respond_to do |f|
      f.html do
        session['flash'] = build_response['message']
        status 301
        headers 'Location' => '/index.html'
      end
      f.json do
        status 201
        body JSON.pretty_generate(build_response) + "\n"
      end
    end
  end

  def title
    @title ||= (ENV['DOCKER_BUILD_SERVER_TITLE'] || 'docker build server')
  end
end
