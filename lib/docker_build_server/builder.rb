# vim:fileencoding=utf-8
require 'rack/builder'
require 'rack/urlmap'
require 'sidekiq/web'

require_relative 'env_basic_auth'

module DockerBuildServer
  class Builder
    def self.app
      dbs = DockerBuildServer::App.new

      Rack::Builder.app do
        if ENV['AUTH_TYPE'] == 'basic'
          realm = ENV['BASIC_AUTH_REALM']
          use Rack::Auth::Basic, realm do |username, password|
            DockerBuildServer::EnvBasicAuth.valid?(username, password)
          end
        end

        run Rack::URLMap.new('/' => dbs, '/sidekiq' => Sidekiq::Web.new)
      end
    end
  end
end
