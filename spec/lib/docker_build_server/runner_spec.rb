# vim:fileencoding=utf-8

describe DockerBuildServer::Runner do
  it 'requires argv' do
    expect { described_class.new }.to raise_error
  end

  context 'without any arguments' do
    subject(:runner) { described_class.new([]) }

    it 'creates a Rack::Server' do
      Rack::Server.should_receive(:new)
        .and_return(double('server', start: nil))
      runner.run!
    end
  end
end
