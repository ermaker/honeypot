require 'database_cleaner'
require 'models/log'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.around(:each) do |example|
    Honeypot::Log.collection.drop
    Honeypot::Log.create_collection
    example.run
    Honeypot::Log.collection.drop
  end
end
