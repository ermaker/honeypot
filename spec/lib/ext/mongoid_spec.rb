require 'app'
require 'models/log'
require 'ext/mongoid'
require 'thread'

RSpec.describe Honeypot::Log do
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
      cached_tailable_cursor = subject.tailable_cursor
      allow(subject).to receive(:tailable_cursor) do
        s.unlock
        cached_tailable_cursor
      end
      s.lock
      Thread.start { s.synchronize(&blk) }
    end

    describe 'with .all' do
      subject { described_class.all }

      it 'works with .all' do
        async_with_tailable_diff do
          described_class.create(value: 0)
          described_class.create(value: 1)
          described_class.create(value: 2)
          described_class.create(value: 3)
        end
        actual = []
        count = 3
        subject.tailable_diff do |prev, now|
          actual.push([prev, now])
          break if (count -= 1).zero?
        end
        actual.map! { |items| items.map(&:attributes_without_id) }
        expect(actual).to match([
          [{ 'value' => 0 }, { 'value' => 1 }],
          [{ 'value' => 1 }, { 'value' => 2 }],
          [{ 'value' => 2 }, { 'value' => 3 }]
        ])
      end
    end

    describe 'with .where' do
      subject { described_class.where(type: 1) }
      it 'works' do
        async_with_tailable_diff do
          described_class.create(type: 0, value: 0)
          described_class.create(type: 1, value: 0)
          described_class.create(type: 0, value: 1)
          described_class.create(type: 1, value: 1)
        end
        actual = subject.tailable_diff do |prev, now|
          break([prev, now])
        end
        actual.map!(&:attributes_without_id)
        expect(actual).to match([
          { 'type' => 1, 'value' => 0 }, { 'type' => 1, 'value' => 1 }
        ])
      end
    end
  end
end
