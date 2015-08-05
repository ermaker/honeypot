require 'app'
require 'models/capped_honey'
require 'thread'

RSpec.describe Honeypot::CappedHoney do
  before do
    described_class.collection.drop
    described_class.create_collection
  end

  after do
    described_class.collection.drop
  end

  it '#tailable_cursor works' do
    described_class.create(value: 0)
    described_class.create(value: 1)
    s = Mutex.new
    cursor = s.synchronize do
      Thread.start do
        s.synchronize do
          described_class.create(value: 2)
        end
      end
      described_class.tailable_cursor
    end
    actual = cursor.map do |_|
      break(
        Honeypot::CappedHoney.desc('_id')
        .limit(1).reverse.map(&:attributes_without_id)
      )
    end
    expect(actual).to match(['value' => 2])
  end

  it '#lazy_diff_cursor works' do
    described_class.create(value: 0)
    described_class.create(value: 1)
    s = Mutex.new
    cursor = s.synchronize do
      Thread.start do
        s.synchronize do
          described_class.create(value: 2)
        end
      end
      described_class.lazy_diff_cursor
    end
    actual = cursor.map do |prev, now|
      [prev, now].map(&:attributes_without_id)
    end.first
    expect(actual).to match([{ 'value' => 1 }, { 'value' => 2 }])
  end
end
