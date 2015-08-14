require 'rails_helper'
require 'models/concerns/tailable_spec'

RSpec.describe Log do
  it_behaves_like 'tailable'

  it '#recent works' do
    create(:log_sw_cert, correct: false)
    create(:log_sw_cert, correct: true)
    create(:log, correct: false)
    actual = described_class.recent(type: :sw_cert).to_a
    expect(actual.size).to eq(1)
    expect(actual.first.correct).to be_truthy
  end
end
