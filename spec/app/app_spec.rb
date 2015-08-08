require 'app'
require 'models/log'

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
    expect(page).to have_title('Honeypot')
    expect(page).to have_content('Hello, Honeypot!')

    visit '/'
    expect(page).not_to have_content('aaa')
    expect(page).not_to have_content(333)
    expect(page).not_to have_content('bbb')
    expect(page).not_to have_content(444)

    create_honey_json(aaa: 333)
    visit '/'
    expect(page).to have_content('aaa')
    expect(page).to have_content(333)
    expect(page).not_to have_content('bbb')
    expect(page).not_to have_content(444)

    create_honey_json(bbb: 444)
    visit '/'
    expect(page).to have_content('aaa')
    expect(page).to have_content(333)
    expect(page).to have_content('bbb')
    expect(page).to have_content(444)
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

  feature 'post /log' do
    scenario 'with empty post' do
      expect do
        page.driver.post('/log', {}.to_json)
      end.to change { Honeypot::Log.all.size }.by(1)
    end

    given(:valid_input) { { 'a' => 3, 'b' => 4 } }

    scenario 'with some json' do
      expect do
        page.driver.post('/log', valid_input.to_json)
      end.to change { Honeypot::Log.all.size }.by(1)
      expect(Honeypot::Log.desc('_id').limit(1).first.attributes)
        .to a_hash_including(valid_input)
    end
  end
end
