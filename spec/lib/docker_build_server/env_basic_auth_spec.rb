# vim:fileencoding=utf-8

describe DockerBuildServer::EnvBasicAuth do
  subject { described_class }

  before { ENV['BASIC_AUTHZ'] = nil }

  it 'returns false when the username is not present' do
    ENV['BASIC_AUTHZ'] = 'zzz:foo'
    subject.valid?('nerf', 'brzzzt').should be_false
  end

  it 'returns false when the password is invalid' do
    ENV['BASIC_AUTHZ'] = 'ack:flurb'
    subject.valid?('ack', 'nurp').should be_false
  end

  it 'returns true when the password is valid' do
    ENV['BASIC_AUTHZ'] = 'dingle:hopper'
    subject.valid?('dingle', 'hopper').should be_true
  end

  it 'builds an authz map from space-separated username:password pairs' do
    ENV['BASIC_AUTHZ'] = 'herp:derp'
    subject.authz_map.should_not be_empty
    subject.authz_map['herp'].should == 'derp'
  end

  it 'url unescapes the authz map key and value' do
    ENV['BASIC_AUTHZ'] = 'zzz%3Ca:2468%20%20%2099'
    subject.authz_map['zzz<a'].should == '2468   99'
  end

  it 'gets the authz value from the env' do
    ENV['BASIC_AUTHZ'] = nil
    subject.authz.should eql('')
    ENV['BASIC_AUTHZ'] = 'zzz'
    subject.authz.should eql('zzz')
  end
end
