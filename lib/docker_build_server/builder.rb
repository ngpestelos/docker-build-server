# vim:fileencoding=utf-8

require 'rack-auth-travis'
require 'rack/builder'
require 'rack/urlmap'
require 'sidekiq/web'

module DockerBuildServer
  class Builder
    def self.app
      dbs = DockerBuildServer::App.new

      Rack::Builder.app do
        run Rack::URLMap.new(
          '/' => dbs,
          '/sidekiq' => Sidekiq::Web.new
        )
      end
    end
  end
end
