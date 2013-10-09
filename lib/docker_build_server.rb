# vim:fileencoding=utf-8
require 'json'
require 'sinatra/base'
require 'sinatra/contrib'

class DockerBuildServer < Sinatra::Base
  register Sinatra::Contrib

  VERSION = '0.1.0'

  get '/' do
    status 301
    headers 'Location' => '/index.html'
  end

  get '/index.html', provides: [:html, :json] do
    respond_to do |f|
      f.html { DOCKER_BUILD_INDEX_HTML.result(binding) }
      f.json { JSON.pretty_generate({ nobody: :home }) }
    end
  end

  post '/docker-build' do
    build_response = {}
    respond_to do |f|
      f.html do
        status 301
        headers 'Location' => '/index.html'
      end
      f.json do
        status 201
        body JSON.pretty_generate(build_response) + "\n"
      end
    end
  end
end

DOCKER_BUILD_INDEX_HTML = ERB.new(<<-EOTMPL)
<!DOCTYPE html>
<html>
  <head>
    <title>Docker Build Server</title>
    <style type="text/css">
      body { font-family: monospace; }
    </style>
  </head>
  <body>
    <h1>Docker Build Server</h1>
    <form name="docker_build" action="/docker-build" method="post">
      <label for="repo">Repo</label>
      <input type="text" name="repo" />
      <label for="ref">Ref</label>
      <input type="text" name="ref" />
      <input type="submit" value="Build!" />
    </form>
  </body>
</html>
EOTMPL
