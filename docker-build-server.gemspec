# vim:fileencoding=utf-8

Gem::Specification.new do |spec|
  spec.name          = 'docker-build-server'
  spec.version       = '0.1.0'
  spec.authors       = ['TODO: Write your name']
  spec.email         = ['TODO: Write your email address']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
