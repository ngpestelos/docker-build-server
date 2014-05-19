# vim:fileencoding=utf-8
require 'multi_json'

module Support
  PAYLOAD_TMPL = {
    'id' => 13_550_100,
    'repository' => {
      'id' => 1_500_429,
      'name' => 'cloaked-octo-nemesis',
      'owner_name' => 'modcloth-labs',
      'url' => nil
    },
    'number' => '4',
    'config' => {
      'language' => 'ruby',
      'install' => 'echo um hum',
      'script' => 'echo wat',
      'notifications' => {
        'webhooks' => {
          'urls' => [
            {
              'secure' => 'ef5mUXxlhrC...'
            }
          ],
          'on_success' => 'always',
          'on_failure' => 'never'
        }
      },
      '.result' => 'configured'
    },
    'status' => 0,
    'result' => 0,
    'status_message' => 'Passed',
    'result_message' => 'Passed',
    'started_at' => '2013-11-06T05:58:46Z',
    'finished_at' => '2013-11-06T05:59:01Z',
    'duration' => 15,
    'build_url' => 'https://travis-ci.org/modcloth-labs/' \
                   'cloaked-octo-nemesis/builds/13550100',
    'commit' => '2ea322561df779c9de6f452ec6b14eff2b58467a',
    'branch' => 'master',
    'message' => 'Pointing at new webhook URL',
    'compare_url' => 'https://github.com/modcloth-labs/' \
                     'cloaked-octo-nemesis/compare/' \
                     '5a03488e375c...2ea322561df7',
    'committed_at' => '2013-11-05T22:04:27Z',
    'author_name' => 'Dan Buch',
    'author_email' => 'd.buch@modcloth.com',
    'committer_name' => 'Dan Buch',
    'committer_email' => 'd.buch@modcloth.com',
    'matrix' => [
      {
        'id' => 13_550_102,
        'repository_id' => 1_500_429,
        'parent_id' => 13_550_100,
        'number' => '4.1',
        'state' => 'finished',
        'config' => {
          'language' => 'ruby',
          'install' => 'echo um hum',
          'script' => 'echo wat',
          'notifications' => {
            'webhooks' => {
              'urls' => [
                {
                  'secure' => 'ef5mUXxlhrCY...'
                }
              ],
              'on_success' => 'always',
              'on_failure' => 'never'
            }
          },
          '.result' => 'configured'
        },
        'status' => nil,
        'result' => nil,
        'commit' => '2ea322561df779c9de6f452ec6b14eff2b58467a',
        'branch' => 'master',
        'message' => 'Pointing at new webhook URL',
        'compare_url' => 'https://github.com/modcloth-labs/' \
                         'cloaked-octo-nemesis/compare/' \
                         '5a03488e375c...2ea322561df7',
        'committed_at' => '2013-11-05T22:04:27Z',
        'author_name' => 'Dan Buch',
        'author_email' => 'd.buch@modcloth.com',
        'committer_name' => 'Dan Buch',
        'committer_email' => 'd.buch@modcloth.com',
        'finished_at' => '2013-11-06T05:59:01Z'
      }
    ],
    'type' => 'push'
  }.freeze

  def self.valid_travis_payload
    PAYLOAD_TMPL.dup
  end

  def self.valid_travis_payload_json
    MultiJson.encode(valid_travis_payload)
  end

  def self.travis_webhook_path
    @travis_webhook_path ||= (ENV['TRAVIS_WEBHOOK_PATH'] || '/travis-webhook')
  end
end
