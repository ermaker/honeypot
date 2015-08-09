require 'app'
require 'models/log'

RSpec.feature Honeypot::App do
  background do
    Capybara.app = described_class
  end

  feature 'post /log' do
    scenario 'with empty post' do
      expect do
        page.driver.post('/log', {}.to_json)
      end.to change { Honeypot::Log.all.size }.by(1)
    end

    given(:valid_input) { { 'a' => 3, 'b' => 4 } }
    given(:last_log) do
      Honeypot::Log.desc('_id').limit(1).first
    end

    scenario 'with some json' do
      expect do
        page.driver.post('/log', valid_input.to_json)
      end.to change { Honeypot::Log.all.size }.by(1)
      expect(last_log.attributes).to a_hash_including(valid_input)
    end
  end
end
