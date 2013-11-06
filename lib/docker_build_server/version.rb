# vim:fileencoding=utf-8

module DockerBuildServer
  VERSION = '0.2.0' unless defined?(VERSION)

  def self.full_version
    return @revision if @revision
    revfile = File.expand_path('../../../REVISION', __FILE__)
    if File.exists?(revfile)
      @revision = File.read(revfile).chomp
    else
      @revision = VERSION
    end
  end
end
