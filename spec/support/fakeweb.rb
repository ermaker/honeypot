RSpec.configure do |config|
  config.before do
    FakeWeb.allow_net_connect = false
  end

  config.after do
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
end
