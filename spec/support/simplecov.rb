if ENV['CI'] || ENV['COV']
  require 'simplecov'
  if ENV['CI']
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  end
  SimpleCov.start('rails')
end
