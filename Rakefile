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

desc 'Run Cov Server'
task cov_server: :cov do
  system(<<-EOC)
      docker run -it --rm \
      -v #{File.expand_path('../coverage', __FILE__)}:/usr/share/nginx/html:ro \
      -p 8080:80 \
      nginx
  EOC
end

task default: [:rubocop, :cov, :yard]
