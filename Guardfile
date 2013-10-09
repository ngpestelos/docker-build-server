# vim:fileencoding=utf-8

def guard_rspec_opts
  if ENV['FOCUS']
    { cli: '--tag focus' }
  else
    {}
  end
end

guard :rspec, guard_rspec_opts do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :shell do
  watch(%r{^.+.rb$}) { system 'rubocop --format simple' }
end
