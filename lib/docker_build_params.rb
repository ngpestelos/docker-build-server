# vim:fileencoding=utf-8

class DockerBuildParams
  def initialize(options = {})
    @options = options
  end

  def to_hash
    JSON.parse(JSON.dump(@options))
  end

  def valid?
    true
  end
end
