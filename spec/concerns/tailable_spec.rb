RSpec.shared_examples_for 'tailable' do
  it 'exists' do
    expect(Tailable).to be_a(Module)
  end

  describe '.create_collection' do
    before do
      described_class.collection.drop
    end

    after do
      described_class.collection.drop
    end

    it 'creates one dummy document' do
      expect do
        described_class.create_collection
      end.to change { described_class.all.size }.by(1)
    end

    it 'runs twice without errors' do
      described_class.create_collection
      described_class.create_collection
    end

    it 'raises an error if not-capped one exists' do
      described_class.create
      expect do
        described_class.create_collection
      end.to raise_error(Moped::Errors::OperationFailure)
    end
  end
end
