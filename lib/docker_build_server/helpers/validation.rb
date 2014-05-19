# rubocop:disable NonNilCheck
# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    module Validation
      URL_REGEX = %r{^(https?|git)://.*}
      REPO_REGEX = %r{^([^/]+/[^/]+|(https?|git)://.*)}
      TAG_REGEX = %r{[^/]+/[^/]+(:.+)?}

      def validate_build_params(build_params)
        if !param_present?('pwd', build_params) || !param_present?('build', build_params)
          ['Both "pwd" and "build" and required']
        else
          []
        end
      end

      private

      def param_present?(param, build_params)
        !build_params[param].nil? && !build_params[param].empty?
      end
    end
  end
end
