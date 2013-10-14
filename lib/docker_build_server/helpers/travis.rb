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
        @travis_payload ||= json_body if json?
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
          tag: "#{travis_docker_build_cfg['tag']}",
          auto_push: !!travis_docker_build_cfg['auto_push'],
          notifications: travis_docker_build_notifications,
        }
      end

      def travis_notifications_campfire
        (travis_payload['config']['notifications'] || {})['campfire']
      end

      def travis_docker_build_notifications
        notify_campfire = travis_docker_build_cfg['notify_campfire']

        if notify_campfire
          if notify_campfire == true
            { campfire: travis_notifications_campfire }
          else
            { campfire: notify_campfire }
          end
        else
          {}
        end
      end
    end
  end
end
