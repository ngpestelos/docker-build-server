# vim:fileencoding=utf-8
require 'uri'

module DockerBuildServer
  class EnvBasicAuth
    def self.valid?(username, password)
      authz_map.key?(username) && authz_map.fetch(username) == password
    end

    def self.authz_map
      authz.split.each_with_object({}) do |u, a|
        key, value = u.split(':', 2)
        a[URI.unescape(key)] = URI.unescape(value)
      end
    end

    def self.authz
      ENV['BASIC_AUTHZ'].to_s
    end
  end
end
