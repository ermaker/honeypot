require 'models/log'
require 'ext/mongoid'
require 'thread'

RSpec.describe Honeypot::Log do
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

    describe 'with a common case' do
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
        subject.tailable_diff do |prev, now|
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

    describe 'with .where' do
      subject { described_class.where(type: 1) }
      let(:critera) { subject }

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
        actual = subject.tailable_diff do |prev, now|
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
