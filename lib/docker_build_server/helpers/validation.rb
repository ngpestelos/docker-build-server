# vim:fileencoding=utf-8

module DockerBuildServer
  module Helpers
    module Validation
      URL_REGEX = %r{^(https?|git)://.*}
      REPO_REGEX = %r{^([^/]+/[^/]+|(https?|git)://.*)}
      TAG_REGEX = %r{[^/]+/[^/]+(:.+)?}

      def validate_build_params(build_params)
        unless param_present?('url', build_params) ||
               param_present?('repo', build_params)
          return ['Either "url" or "repo" is required']
        end

        return validate_url_given(build_params) if
          param_present?('url', build_params)

        validate_repo_given(build_params)
      end

      private

      def param_present?(param, build_params)
        !build_params[param].nil? && !build_params[param].empty?
      end

      def validate_url_given(build_params)
        return [
          %Q{The "url" must match #{URL_REGEX.inspect}}
        ] if build_params['url'] !~ URL_REGEX

        %w(repo ref).each do |field|
          return [
            %Q{If "url" is provided, then "#{field}" must not be present}
          ] if param_present?(field, build_params)
        end

        validate_auto_push_given(build_params)
      end

      def validate_repo_given(build_params)
        return [
          %Q{The "repo" must be a github <account>/<repo> or full URL}
        ] unless build_params['repo'] =~ REPO_REGEX

        []
      end

      def validate_auto_push_given(build_params)
        return [] unless build_params['auto_push']

        return [
          'The "tag" must be given when "auto-push" is set'
        ] unless build_params['tag']

        return [
          %Q{The "tag" must match #{TAG_REGEX.inspect}}
        ] if build_params['tag'] !~ TAG_REGEX

        []
      end
    end
  end
end
