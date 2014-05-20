# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    module All
      def docker_build(params)
        build_params = BuildParams.new(params.to_hash)
        DockerBuild.perform_async(build_params.to_hash)

        return build_params.to_hash.merge(
          'message' => "Building #{params['url'].inspect}"
        ) if params['url']

        build_params.to_hash.merge(
          'message' => "Building #{params['repo'].inspect} at #{params['ref'].inspect}"
        )
      end

      include JSON
      include Title
      include Travis
      include Validation
    end
  end
end
