require 'app'
require 'models/honey'

RSpec.feature Honeypot::App do
  background do
    Capybara.app = described_class
  end

  scenario 'get /' do
    visit '/'
    expect(page).to have_title('Honeypot')
    expect(page).to have_content('Hello, Honeypot!')
  end

  scenario 'get and post /new/raw' do
    raw = { 'a' => 3, 'b' => 4 }
    visit '/new/raw'
    within('#new_honey') do
      fill_in :raw, with: raw.to_json
      click_button('')
    end
    expect(Honeypot::Honey.all.size).to eq(1)
    expect(Honeypot::Honey.first.attributes).to a_hash_including(raw)
  end
end
