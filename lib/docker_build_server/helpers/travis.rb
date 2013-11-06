# vim:fileencoding=utf-8
require 'multi_json'
require 'rack-auth-travis'
require_relative 'json'

module DockerBuildServer
  module Helpers
    module Travis
      include DockerBuildServer::Helpers::JSON

      def rack_auth_travis_request
        @rack_auth_travis_request ||= Rack::Auth::Travis::Request.new(
          request.env, settings.travis_authenticators
        )
      end

      def travis_authorized?
        rack_auth_travis_request.valid?
      end

      def travis_payload
        @raw_payload ||= params[:payload]
        @travis_payload ||= MultiJson.decode(@raw_payload) if @raw_payload
        @travis_payload ||= json_body['payload'] if json?
        @travis_payload
      end

      def travis_docker_build_cfg
        @travis_docker_build_cfg ||= (
          travis_payload['config'] || {}
        )['docker_build'] || {}
      end

      def travis_docker_build_disabled?
        !!travis_docker_build_cfg['disable']
      end

      def travis_build_params
        {
          repo: "#{travis_payload['repository']['url']}",
          ref: "#{travis_payload['commit']}",
          tag: "#{travis_docker_build_cfg['tag']}"
               .gsub(/\$TRAVIS_COMMIT/, "#{travis_payload['commit']}"),
          auto_push: !!travis_docker_build_cfg['auto_push'],
          notifications: travis_docker_build_notifications,
        }
      end

      def travis_notifications(section)
        cfg = (travis_payload['config']['notifications'] || {})[section]
        return cfg['rooms'].first if cfg.is_a?(Hash)
        cfg
      end

      def travis_docker_build_notifications
        notifications = {}

        %w(campfire hipchat).each do |section|
          cfg = travis_docker_build_cfg["notify_#{section}"]

          notifications.merge!(
            section.to_sym => travis_notifications(section)
          ) && next if cfg == true

          notifications.merge!(section.to_sym => cfg) if cfg
        end

        notifications
      end
    end
  end
end
