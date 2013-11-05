# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    autoload :All, 'docker_build_server/helpers/all'
    autoload :JSON, 'docker_build_server/helpers/json'
    autoload :Title, 'docker_build_server/helpers/title'
    autoload :Travis, 'docker_build_server/helpers/travis'
    autoload :Validation, 'docker_build_server/helpers/validation'
  end
end
