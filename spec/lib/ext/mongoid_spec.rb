require 'thread'

class TestModel # rubocop:disable Style/Documentation
  include Mongoid::Document
  include Tailable
  field :type, type: Integer
  field :value, type: Integer

  GENERATED_KEYS = %w(_id c_at)

  # @return [Hash] Attributes except '_id' and 'c_at'
  def attributes_without_generated_values
    attributes.reject { |k, _| GENERATED_KEYS.include?(k) }
  end
end

RSpec.describe TestModel do
  before do
    described_class.collection.drop
    described_class.create_collection
  end

  after do
    described_class.collection.drop
  end

  describe '#tailable_diff' do
    def async_with_tailable_diff(&blk)
      s = Mutex.new
      cached_tailable_cursor = critera.tailable_cursor
      allow(critera).to receive(:tailable_cursor) do
        s.unlock
        cached_tailable_cursor
      end
      s.lock
      Thread.start { s.synchronize(&blk) }
    end

    describe 'with a common critera' do
      subject { described_class.where(:value.exists => true) }
      let(:critera) { subject }

      it 'works' do
        async_with_tailable_diff do
          described_class.create(value: 0)
          described_class.create(value: 1)
          described_class.create(value: 2)
          described_class.create(value: 3)
        end
        actual = []
        count = 3
        critera.tailable_diff do |prev, now|
          actual.push([prev, now])
          break if (count -= 1).zero?
        end
        actual.map! { |items| items.map(&:attributes_without_generated_values) }
        expect(actual).to match([
          [{ 'value' => 0 }, { 'value' => 1 }],
          [{ 'value' => 1 }, { 'value' => 2 }],
          [{ 'value' => 2 }, { 'value' => 3 }]
        ])
      end
    end

    describe 'with critera#where' do
      subject { described_class.where(type: 1) }
      let(:critera) { subject }

      it 'works' do
        async_with_tailable_diff do
          described_class.create(type: 0, value: 0)
          described_class.create(type: 1, value: 0)
          described_class.create(type: 0, value: 1)
          described_class.create(type: 1, value: 1)
        end
        actual = critera.tailable_diff do |prev, now|
          break([prev, now])
        end
        actual.map!(&:attributes_without_generated_values)
        expect(actual).to match([
          { 'type' => 1, 'value' => 0 }, { 'type' => 1, 'value' => 1 }
        ])
      end

      it 'works with existing values' do
        described_class.create(type: 1, value: 0)
        async_with_tailable_diff do
          described_class.create(type: 1, value: 1)
        end
        actual = critera.tailable_diff do |prev, now|
          break([prev, now])
        end
        actual.map!(&:attributes_without_generated_values)
        expect(actual).to match([
          { 'type' => 1, 'value' => 0 }, { 'type' => 1, 'value' => 1 }
        ])
      end
    end
  end
end
