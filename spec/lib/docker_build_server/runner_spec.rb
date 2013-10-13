# vim:fileencoding=utf-8

describe DockerBuildServer::Runner do
  it 'requires argv' do
    expect { described_class.new }.to raise_error
  end

  context 'without any arguments' do
    subject(:runner) { described_class.new([]) }

    it 'calls Rack::Server.start' do
      Rack::Server.should_receive(:start)
      runner.run!
    end
  end
end
