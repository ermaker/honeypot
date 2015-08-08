require 'app'

RSpec.describe Honeypot::Log do
  describe '#create_collection' do
    it 'works when the collection exists' do
      expect do
        described_class.create_collection
      end.to change { Honeypot::Log.all.size }.by(0)
    end

    it 'works when the collection exists but is not capped' do
      described_class.collection.drop
      described_class.create
      expect do
        described_class.create_collection
      end.to raise_error(Moped::Errors::OperationFailure)
    end
  end
end
