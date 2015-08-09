require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'
require File.expand_path('../config/environment', __FILE__)

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

namespace :db do
  desc 'Create Database'
  task :create do
    require 'models/log'
    Honeypot::Log.create_collection
  end
end

namespace :worker do
  desc 'Run SWCert worker'
  task :sw_cert do
    require 'honeypot/worker'
    require 'honeypot/sw_cert'
    Honeypot::Worker.new(Honeypot::SWCert.new).run
  end
end
