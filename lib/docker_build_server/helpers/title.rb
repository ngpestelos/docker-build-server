# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    module Title
      def title
        @title ||= (ENV['DOCKER_BUILD_SERVER_TITLE'] || 'docker build server')
      end
    end
  end
end
