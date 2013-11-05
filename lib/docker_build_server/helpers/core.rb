# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    module Core
      def docker_build(params)
        build_params = BuildParams.new(params.to_hash)
        DockerBuild.perform_async(build_params.to_hash)

        return build_params.to_hash.merge(
          'message' => "Building #{params['url'].inspect}"
        ) if params['url']

        build_params.to_hash.merge(
          'message' => "Building #{params['repo'].inspect} " <<
          "at #{params['ref'].inspect}"
        )
      end
    end
  end
end
