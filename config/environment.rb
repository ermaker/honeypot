require 'sinatra/base'
require 'mongoid'

%w(app lib config).each do |dir|
  path = File.expand_path("../../#{dir}", __FILE__)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

Sinatra::Base.configure do
  Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))
end
