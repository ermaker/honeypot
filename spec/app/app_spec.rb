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

  feature 'get and post /new/raw' do
    given(:valid_input) { { 'a' => 3, 'b' => 4 } }

    scenario 'with valid input' do
      visit '/new/raw'
      within('#new_honey') do
        fill_in :raw, with: valid_input.to_json
        click_button('')
      end
      expect(Honeypot::Honey.all.size).to eq(1)
      expect(Honeypot::Honey.first.attributes).to a_hash_including(valid_input)
    end

    given(:invalid_input_json) { '' }
    scenario 'with invalid input' do
      visit '/new/raw'
      within('#new_honey') do
        fill_in :raw, with: invalid_input_json
        expect { click_button('') }.to raise_error(JSON::ParserError)
      end
    end
  end
end
