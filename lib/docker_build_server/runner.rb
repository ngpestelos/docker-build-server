# vim:fileencoding=utf-8

require 'rack/handler'
require 'rack/server'

module DockerBuildServer
  class Runner
    attr_accessor :argv

    def initialize(argv)
      @argv = argv
    end

    def run!
      if argv.include?('--version')
        print_version
        return
      end
      options = Rack::Server::Options.new.parse!(@argv)
      Rack::Server.new(
        options.merge(app: DockerBuildServer.app)
      ).start
    end

    private

    def print_version
      puts 'docker-build-server ' <<
           DockerBuildServer.full_version
    end
  end
end
