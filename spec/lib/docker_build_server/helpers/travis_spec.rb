# vim:fileencoding=utf-8

describe DockerBuildServer::Helpers::Travis do
  subject(:helped) do
    Class.new do
      include DockerBuildServer::Helpers::Travis
    end.new
  end

  let :env do
    {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_AUTHORIZATION' => 'a' * 64,
    }
  end

  let :request do
    Rack::MockRequest.new(->(env) { [200, {}, []] }).tap do |req|
      req.stub(env: env)
    end
  end

  let :settings do
    double('settings', travis_authenticators: [:foo, :bar])
  end

  before do
    helped.stub(
      settings: settings,
      request: request,
      json?: true
    )
  end

  it 'uses the travis authenticators from settings' do
    req = helped.rack_auth_travis_request
    req.instance_variable_get(:@authenticators).should == [:foo, :bar]
  end

  it 'delegates `#travis_authorized?` to the rack auth travis request' do
    helped.stub(rack_auth_travis_request: double('req', valid?: :foo))
    helped.travis_authorized?.should == :foo
  end

  it 'uses the params payload if present' do
    helped.stub(params: { payload: '{"foo":"bar"}' })
    helped.travis_payload.should == { 'foo' => 'bar' }
  end

  let(:tag) { "fizz.example.com/buzz:#{rand(100..199)}" }
  let(:campfire_cfg) { "flurb:a1b2c3d4@#{rand(50_000..59_999)}" }
  let(:travis_campfire_cfg) { "brrzzt:fabfabfab@#{rand(40_000..49_999)}" }

  let :travis_payload do
    {
      'repository' => { 'url' => 'zzz' },
      'commit' => 'a1b2c3d4',
      'config' => {
        'docker_build' => {
          'tag' => tag,
          'notify_campfire' => campfire_cfg
        },
        'notifications' => {
          'campfire' => travis_campfire_cfg
        }
      }
    }
  end

  it 'constructs build params from payload and docker build config' do
    helped.stub(travis_payload: travis_payload)
    helped.travis_build_params.should == {
      repo: 'zzz',
      ref: 'a1b2c3d4',
      tag: tag,
      auto_push: false,
      notifications: { campfire: campfire_cfg }
    }
  end

  context 'when notify_campfire is absent' do
    before do
      helped.stub(travis_payload: travis_payload.tap do |p|
        p['config']['docker_build']['notify_campfire'] = nil
      end)
    end

    it 'passes no campfire notification config' do
      helped.travis_build_params[:notifications][:campfire].should be_nil
    end
  end

  context 'when notify_campfire is true' do
    before do
      helped.stub(travis_payload: travis_payload.tap do |p|
        p['config']['docker_build']['notify_campfire'] = true
      end)
    end

    it 'uses the travis campfire notification identifier' do
      helped.travis_build_params[:notifications][:campfire]
        .should == travis_campfire_cfg
    end
  end
end
