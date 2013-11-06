# vim:fileencoding=utf-8

describe DockerBuildServer::App do
  include Rack::Test::Methods

  def app
    DockerBuildServer.app
  end

  before do
    ENV['VERSION'] = '11'
    ENV['AUTH_TYPE'] = 'basic'
    authorize 'fizz', 'buzz'
    DockerBuild.stub(:perform_async)
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
    it 'includes the "Docker-Build-Server-Version" header' do
      get '/index.html'
      last_response.headers.should include('Docker-Build-Server-Version')
      last_response.headers['Docker-Build-Server-Version'].should == '11'
    end

    context 'when request method is GET' do
      before { get '/index.html' }

      it 'is text/html' do
        last_response.content_type.should =~ /text\/html\s*;\s*charset=utf-8/
      end

      it 'has a form for requesting builds' do
        last_response.body.should =~ /form.*name="docker_build"/im
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

  describe 'POST /docker-build' do
    context 'when Accept is application/json' do
      before do
        post '/docker-build', '{"repo":"octocat/KnifeSpoon","ref":"bar"}',
             'HTTP_ACCEPT' => 'application/json',
             'CONTENT_TYPE' => 'application/json'
      end

      let(:body) { JSON.parse(last_response.body) }

      it 'includes the "Docker-Build-Server-Version" header' do
        last_response.headers.should include('Docker-Build-Server-Version')
        last_response.headers['Docker-Build-Server-Version'].should == '11'
      end

      it 'is application/json' do
        last_response.content_type.should =~
        /application\/json\s*;\s*charset=utf-8/
      end

      it 'is valid JSON' do
        body.should_not be_nil
      end

      it 'responds 201' do
        last_response.status.should == 201
      end
    end

    context 'when Accept is text/html' do
      before do
        post '/docker-build', {
          'repo' => 'octocat/KnifeSpoon', 'ref' => 'bar'
        }, 'HTTP_ACCEPT' => 'text/html'
      end

      it 'includes the "Docker-Build-Server-Version" header' do
        last_response.headers.should include('Docker-Build-Server-Version')
        last_response.headers['Docker-Build-Server-Version'].should == '11'
      end

      it 'redirects to "/index.html"' do
        last_response.status.should eql(301)
        last_response.location.should =~ /index\.html$/
      end
    end

    context 'when the build params are invalid' do
      context 'when Accept is text/html' do
        before do
          post '/docker-build', { 'url' => 'herp' },
               'HTTP_ACCEPT' => 'text/html'
        end

        it 'responds 400' do
          last_response.status.should eql(400)
        end
      end

      context 'when Accept is application/json' do
        before do
          post '/docker-build', '{"url":"herp"}',
               'HTTP_ACCEPT' => 'application/json',
               'CONTENT_TYPE' => 'application/json'
        end

        it 'responds 400' do
          last_response.status.should eql(400)
        end
      end
    end

    describe Support.travis_webhook_path do
      before { ENV['AUTH_TYPE'] = 'travis' }

      context 'when travis authorization is invalid' do
        before { described_class.any_instance.stub(travis_authorized?: false) }

        it 'responds 401' do
          post Support.travis_webhook_path,
               'payload' => Support.valid_travis_payload_json
          last_response.status.should == 401
        end

        it 'includes the "Docker-Build-Server-Version" header' do
          post Support.travis_webhook_path,
               'payload' => Support.valid_travis_payload_json
          last_response.headers.should include('Docker-Build-Server-Version')
          last_response.headers['Docker-Build-Server-Version'].should == '11'
        end
      end

      context 'when travis authorization is valid' do
        before do
          described_class.any_instance.stub(
            travis_authorized?: true,
            docker_build: {},
            travis_build_params: {},
          )
        end

        context 'when travis payload is missing' do
          it 'responds 400' do
            post Support.travis_webhook_path
            last_response.status.should == 400
          end
        end

        context 'when docker build is disabled in the travis config' do
          before do
            described_class.any_instance.stub(
              travis_docker_build_disabled?: true
            )
          end

          it 'responds 204' do
            post Support.travis_webhook_path,
                 'payload' => Support.valid_travis_payload_json
            last_response.status.should == 204
          end

          it 'includes the "Docker-Build-Server-Version" header' do
            post Support.travis_webhook_path,
                 'payload' => Support.valid_travis_payload_json
            last_response.headers.should include('Docker-Build-Server-Version')
            last_response.headers['Docker-Build-Server-Version'].should == '11'
          end
        end

        it 'responds 201' do
          post Support.travis_webhook_path,
               'payload' => Support.valid_travis_payload_json
          last_response.status.should == 201
        end
      end
    end
  end
end
