# vim:fileencoding=utf-8
require 'sidekiq'

class DockerBuild
  include Sidekiq::Worker
  sidekiq_options queue: (ENV['DOCKER_BUILD_QUEUE'] || 'docker-build')

  def perform(*)
    fail 'Out of order. ~mgmt'
  end
end
