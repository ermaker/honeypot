require 'sinatra/base'
require 'tilt/haml'
require 'mongoid'

# The main module
module Honeypot
  # The main app class
  class App < Sinatra::Base
    configure do
      Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))
    end

    get '/' do
      haml :index
    end
  end
end
