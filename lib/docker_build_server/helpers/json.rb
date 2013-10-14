# vim:fileencoding=utf-8
require 'multi_json'

module DockerBuildServer
  module Helpers
    module JSON
      def json_body
        @json_body ||= MultiJson.decode(request.body)
      end

      JSON_REGEXP = /^application\/([\w!#\$%&\*`\-\.\^~]*\+)?json$/i

      def json?
        request.env['CONTENT_TYPE'] =~ JSON_REGEXP
      end
    end
  end
end
