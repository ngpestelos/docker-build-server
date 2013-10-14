# vim:fileencoding=utf-8

module DockerBuildServer
  class BuildParams
    def initialize(options = {})
      @options = options
      @options['auto_push'] = %w(true 1 yes on).include?(
        (@options.delete('auto_push') || '').downcase
      )
    end

    def to_hash
      JSON.parse(JSON.dump(@options))
    end

    def valid?
      return false if @options['repo'].nil?
      return false if @options['ref'].nil?
      return false unless [true, false].include?(@options['auto_push'])
      true
    end
  end
end
