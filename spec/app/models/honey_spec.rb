require 'app'
require 'models/honey'

RSpec.describe Honeypot::Honey do
  let(:params) { { 'aaa' => 333, 'bbb' => 444 } }

  it 'saves anything' do
    described_class.new(params).save
    expect(described_class.all.size).to eq(1)
    expect(described_class.first.aaa).to eq(params['aaa'])
    expect(described_class.first.bbb).to eq(params['bbb'])
  end

  describe '#attributes_without_id' do
    it 'works when empty' do
      expect(subject.attributes).to be_a(Hash)
      expect(subject.attributes_without_id).to be_empty
      expect(subject.attributes_without_id).to be_a(Hash)
    end

    it 'works empty' do
      subject = described_class.new(params)
      expect(subject.attributes).to be_a(Hash)
      expect(subject.attributes).to a_hash_including(params)
      expect(subject.attributes_without_id).to be_a(Hash)
      expect(subject.attributes_without_id).to match(params)
    end
  end
end
