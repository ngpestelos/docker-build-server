# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    autoload :JSON, 'docker_build_server/helpers/json'
    autoload :Travis, 'docker_build_server/helpers/travis'
    autoload :Validation, 'docker_build_server/helpers/validation'
  end
end
