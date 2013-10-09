require 'bundler/gem_tasks'

desc 'Run rubocop'
task :rubocop do
  sh('rubocop --config .rubocop.yml --format simple') { |r, _| r || abort }
end
