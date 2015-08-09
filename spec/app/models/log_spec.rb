require 'app'

RSpec.describe Honeypot::Log do
  describe '#create_collection' do
    it 'works when the collection exists' do
      expect do
        described_class.create_collection
      end.to change { described_class.all.size }.by(0)
    end

    it 'works when the collection exists but is not capped' do
      described_class.collection.drop
      described_class.create
      expect do
        described_class.create_collection
      end.to raise_error(Moped::Errors::OperationFailure)
    end
  end

  let(:last_log) do
    described_class.desc('_id').limit(1).first
  end

  it 'works with an array' do
    data = { status: [1, 2, 3] }
    expect do
      described_class.create(data)
    end.to change { described_class.all.size }.by(1)
    expect(last_log.status).to eq(data[:status])
  end
end
