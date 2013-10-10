# vim:fileencoding=utf-8

describe DockerBuild do
  it 'explodes' do
    expect { subject.perform }.to raise_error
  end
end
