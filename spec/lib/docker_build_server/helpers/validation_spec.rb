# vim:fileencoding=utf-8

describe DockerBuildServer::Helpers::Validation do
  subject :helped do
    Class.new do
      include DockerBuildServer::Helpers::Validation
    end.new
  end

  context 'when no url or repo is given' do
    let(:build_params) { {} }

    it 'returns errors' do
      helped.validate_build_params(build_params).should_not be_empty
    end

    it 'includes an error that either the url or repo is required' do
      errors = helped.validate_build_params(build_params)
      errors.first.should =~ /either.*url.*or.*repo.*is.*required/i
    end
  end

  context 'when url is given' do
    let :build_params do
      {
        'url' => 'https://raw.github.com/octocat/KnifeSpoon/master/Dockerfile'
      }
    end

    it 'returns no errors' do
      helped.validate_build_params(build_params).should be_empty
    end

    context 'when auto-push is given' do
      let :build_params do
        {
          'url' => 'https://raw.github.com/foo/Bars/master/Dockerfile',
          'auto_push' => true,
          'tag' => 'foo/bars'
        }
      end

      it 'returns no errors' do
        helped.validate_build_params(build_params).should be_empty
      end

      context 'when no tag is given' do
        let :build_params do
          {
            'url' => 'https://raw.github.com/foo/Bars/master/Dockerfile',
            'auto_push' => true
          }
        end

        it 'returns errors' do
          helped.validate_build_params(build_params).should_not be_empty
        end

        it 'includes an error that the tag must be given' do
          errors = helped.validate_build_params(build_params)
          errors.first.should =~
            /the.*tag.*must.*be.*given.*when.*auto-push.*is.*set/i
        end
      end

      context 'when the tag is invalid' do
        let :build_params do
          {
            'url' => 'https://raw.github.com/derrr/Shiv/master/Dockerfile',
            'auto_push' => true,
            'tag' => 'brzzzzt'
          }
        end

        it 'returns errors' do
          helped.validate_build_params(build_params).should_not be_empty
        end

        it 'includes an error that the tag must match a specific regex' do
          errors = helped.validate_build_params(build_params)
          errors.first.should =~ /the.*tag.*must.*match\s+.+/i
        end
      end
    end

    context 'when url is invalid' do
      let :build_params do
        { 'url' => 'ftp://derpderp.example.com:9949/fizz/Dockerfile' }
      end

      it 'returns errors' do
        helped.validate_build_params(build_params).should_not be_empty
      end

      it 'includes an error that the url must match a specific regex' do
        errors = helped.validate_build_params(build_params)
        errors.first.should =~ /the.*url.*must.*match\s+.+/i
      end
    end
  end
end
