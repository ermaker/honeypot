require 'sinatra/base'
require 'environment'
require 'models/log'

# The main module
module Honeypot
  # The main app class
  class App < Sinatra::Base
    post '/log' do
      request.body.rewind
      raw = request.body.read
      Log.create(JSON.parse(raw)) unless raw.empty?
    end
  end
end
