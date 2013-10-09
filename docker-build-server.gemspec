# vim:fileencoding=utf-8

Gem::Specification.new do |spec|
  spec.name          = 'docker-build-server'
  spec.version       = '0.1.0'
  spec.authors       = ['Dan Buch', 'Nicola Adamchik']
  spec.email         = ['d.buch@modcloth.com', 'n.adamchik@modcloth.com']
  spec.summary       = %q{HTTP Server that receives requests for docker build jobs}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/modcloth-labs/docker-build-worker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'sinatra-contrib'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-shell'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'shotgun'
end
