# vim:fileencoding=utf-8

require 'rack/handler'
require 'rack/server'

module DockerBuildServer
  class Runner
    attr_accessor :args

    def initialize(argv)
      @argv = argv
    end

    def run!
      options = Rack::Server::Options.new.parse!(@argv)
      Rack::Server.new(
        options.merge(app: DockerBuildServer.app)
      ).start
    end
  end
end
