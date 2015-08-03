require 'app'
require 'models/honey'

RSpec.feature Honeypot::App do
  background do
    Capybara.app = described_class
  end

  def create_honey(input)
    visit '/new/raw'
    within('#new_honey') do
      fill_in :raw, with: input
      click_button('')
    end
  end

  def create_honey_json(input)
    create_honey(input.to_json)
  end

  scenario 'get /' do
    visit '/'
    expect(page).not_to have_content('a')
    expect(page).not_to have_content(3)
    expect(page).not_to have_content('b')
    expect(page).not_to have_content(4)

    create_honey_json(a: 3)
    visit '/'
    expect(page).to have_content('a')
    expect(page).to have_content(3)
    expect(page).not_to have_content('b')
    expect(page).not_to have_content(4)

    create_honey_json(b: 4)
    visit '/'
    expect(page).to have_content('a')
    expect(page).to have_content(3)
    expect(page).to have_content('b')
    expect(page).to have_content(4)
  end

  feature 'get and post /new/raw' do
    given(:valid_input) { { 'a' => 3, 'b' => 4 } }

    scenario 'with valid input' do
      create_honey_json(valid_input)
      expect(Honeypot::Honey.all.size).to eq(1)
      expect(Honeypot::Honey.first.attributes).to a_hash_including(valid_input)
    end

    given(:invalid_input_json) { '' }
    scenario 'with invalid input' do
      expect do
        create_honey(invalid_input_json)
      end.to raise_error(JSON::ParserError)
    end
  end
end
