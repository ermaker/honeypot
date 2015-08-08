require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
require File.expand_path('../config/environment', __FILE__)

use Rack::Timeout
Rack::Timeout.timeout = 5

require 'app'

run Honeypot::App
