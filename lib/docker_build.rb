# vim:fileencoding=utf-8
require 'sidekiq'

class DockerBuild
  include Sidekiq::Worker

  def perform(*)
    fail 'Out of order. ~mgmt'
  end
end
