require 'rails_helper'

RSpec.describe Log do
  it_behaves_like 'tailable'

  describe '.recent' do
    it 'works' do
      create(:log_sw_cert, correct: false)
      create(:log_sw_cert, correct: true)
      create(:log, correct: false)
      expect(described_class.recent(type: :sw_cert).correct).to be_truthy
    end

    it 'works without logs' do
      expect(described_class.recent(type: :sw_cert)).to be_nil
    end
  end

  describe '.sw_cert_candidates' do
    it 'works' do
      create(:log_sw_cert)
      expect(described_class.sw_cert_candidates.size).to eq(8)
    end
  end
end
