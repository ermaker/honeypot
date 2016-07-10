RSpec.shared_examples_for 'tailable' do
  before do
    described_class.collection.drop
  end

  after do
    described_class.collection.drop
  end

  it 'exists' do
    expect(Tailable).to be_a(Module)
  end

  describe '.create_collection_tailable!' do
    it 'creates on empty environment' do
      expect do
        described_class.create_collection_tailable!
      end.to change { described_class.all.size }.by(1)
    end

    it 'goes alright with a precreated collection' do
      described_class.create_collection_tailable!
      expect do
        described_class.create_collection_tailable!
      end.not_to raise_error
    end

    it 'recreates with a non-capped collection' do
      described_class.create
      expect(described_class.collection).not_to be_capped
      described_class.create_collection_tailable!
      expect(described_class.all.size).to eq(1)
      expect(described_class.collection).to be_capped
    end

    it 'DOES NOT recreate collection if it already exists' do
      described_class.create_collection_tailable!
      described_class.create(value: true)
      described_class.create_collection_tailable!
      expect(described_class.order(_id: :desc).first[:value]).to \
        be_truthy
    end
  end
end
