require 'sinatra/base'
require 'sinatra/partial'
require 'tilt/haml'
require 'mongoid'
require 'models/honey'
require 'models/log'

# The main module
module Honeypot
  # The main app class
  class App < Sinatra::Base
    configure do
      Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))
      register Sinatra::Partial
    end

    get '/' do
      haml :index, locals: { honey_list: Honey.all }
    end

    get '/new/raw' do
      haml :new_raw
    end

    post '/new/raw' do
      Honey.create(JSON.parse(params[:raw]))
    end

    post '/log' do
      request.body.rewind
      raw = request.body.read
      Log.create(JSON.parse(raw)) unless raw.empty?
    end
  end
end
