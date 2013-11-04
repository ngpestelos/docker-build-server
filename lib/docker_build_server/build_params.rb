# vim:fileencoding=utf-8

module DockerBuildServer
  class BuildParams
    def initialize(options = {})
      @options = options
      @options['auto_push'] = %w(true 1 yes on).include?(
        (@options.delete('auto_push') || '').to_s.downcase
      )
    end

    def to_hash
      JSON.parse(JSON.dump(@options))
    end
  end
end
