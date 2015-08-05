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

  it 'works' do
    described_class.create(value: 0)
    described_class.create(value: 1)
    s = Mutex.new
    cursor = s.synchronize do
      Thread.start do
        puts 'Thread start'
        s.synchronize do
          puts 'Thread in'
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
end
