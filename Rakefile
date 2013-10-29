# vim:fileencoding=utf-8
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-f doc'
end

desc 'Run rubocop'
task :rubocop do
  sh('rubocop --format simple') { |ok, _| ok || abort }
end

task default: [:rubocop, :spec]

desc 'Build the docker container'
task :container do
  sh(%W(docker build
    -t quay.io/modcloth/docker-build-server:#{ENV['TAG'] || 'latest'}
    #{File.expand_path('../', __FILE__)}
  ).join(' ')) { |ok, _| ok || abort }
end
