# vim:fileencoding=utf-8

module DockerBuildServer
  autoload :App, 'docker_build_server/app'
  autoload :BuildParams, 'docker_build_server/build_params'
  autoload :Builder, 'docker_build_server/builder'
  autoload :Helpers, 'docker_build_server/helpers'
  autoload :Runner, 'docker_build_server/runner'
  autoload :VERSION, 'docker_build_server/version'

  def app
    Builder.app
  end

  module_function :app
end
