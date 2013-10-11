# vim:fileencoding=utf-8

describe 'Docker Build Server API' do
  include Rack::Test::Methods

  def app
    DockerBuildServer.new
  end

  it 'redirects "GET /" to "GET /index.html"' do
    get '/'
    last_response.status.should eql(301)
    last_response.location.should =~ /index\.html$/
  end

  it 'responds to "GET /index.html"' do
    get '/index.html'
    last_response.status.should == 200
  end

  describe '/index.html' do
    context 'when request method is GET' do
      before { get '/index.html' }
      let(:doc) { Nokogiri::HTML(last_response.body) }

      it 'is text/html' do
        last_response.content_type.should =~ /text\/html\s*;\s*charset=utf-8/
      end

      it 'has a form for requesting builds' do
        doc.css('form[name="docker_build"]').first.should_not be_nil
      end
    end

    %w(POST PUT DELETE).each do |request_method|
      context "when request method is #{request_method}" do
        before { send(request_method.downcase, '/index.html') }

        it 'responds 404' do
          last_response.status.should == 404
        end
      end
    end
  end

  it 'responds to "POST /docker-build"' do
    post '/docker-build', '{"repo":"foo","ref":"bar"}',
         { 'HTTP_ACCEPT' => 'application/json' }
    last_response.status.should == 201
  end

  describe '/docker-build' do
    context 'when Accept is application/json' do
      before do
        post '/docker-build', '{"repo":"foo","ref":"bar"}',
             { 'HTTP_ACCEPT' => 'application/json' }
      end

      let(:body) { JSON.parse(last_response.body) }

      it 'is application/json' do
        last_response.content_type.should =~
          /application\/json\s*;\s*charset=utf-8/
      end

      it 'is valid JSON' do
        body.should_not be_nil
      end
    end

    context 'when Accept is text/html' do
      before do
        post '/docker-build', { 'repo' => 'foo', 'ref' => 'bar' },
             { 'HTTP_ACCEPT' => 'text/html' }
      end

      let(:body) { JSON.parse(last_response.body) }

      it 'redirects to "/index.html"' do
        last_response.status.should eql(301)
        last_response.location.should =~ /index\.html$/
      end
    end
  end
end
