# vim:fileencoding=utf-8
require 'multi_json'

module Support
  def travis_webhook_path
    @travis_webhook_path ||= (ENV['TRAVIS_WEBHOOK_PATH'] || '/travis-webhook')
  end

  module_function :travis_webhook_path

  def valid_travis_payload
    {}
  end

  def valid_travis_payload_json
    '{}'
  end
end
