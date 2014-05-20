# vim:fileencoding=utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_build_server/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name = 'docker-build-server'
  spec.version = DockerBuildServer::VERSION
  spec.authors = ['Dan Buch', 'Nicola Adamchik', 'Rafe Colton']
  spec.email = ['d.buch@modcloth.com', 'n.adamchik@modcloth.com', 'r.colton@modcloth.com']
  spec.summary = %q(HTTP Server that receives requests for docker build jobs)
  spec.description = spec.summary
  spec.homepage = 'https://github.com/modcloth-labs/docker-build-worker'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($RS)
  spec.executables = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'rack-auth-travis'
  spec.add_runtime_dependency 'sidekiq'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'sinatra-contrib'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'foreman'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-shell'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'shotgun'
end
