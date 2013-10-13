# vim:fileencoding=utf-8

require 'rack/server'

module DockerBuildServer
  class Runner
    attr_accessor :args

    def initialize(argv)
      @argv = argv
    end

    def run!
      Rack::Server.start(app)
    end

    private

    def app
      Builder.app
    end
  end
end
