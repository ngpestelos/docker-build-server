if ENV['COVERAGE']
  SimpleCov.start do
    add_filter '/spec/'
    minimum_coverage 95
    refuse_coverage_drop
  end
end
