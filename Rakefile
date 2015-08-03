require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new

desc 'Run SimpleCov'
task :cov do
  ENV['COV'] = 'true'
  Rake::Task[:spec].execute
end

task default: [:rubocop, :cov, :yard]
