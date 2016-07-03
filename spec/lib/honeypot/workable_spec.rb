require 'rails_helper'

RSpec.describe TestWorker do
  def async_with_tailable_diff(&blk)
    s = Mutex.new
    cached_tailable_cursor = critera.tailable_cursor
    allow_any_instance_of(critera.class).to receive(:tailable_cursor) do
      s.unlock
      cached_tailable_cursor
    end
    s.lock
    Thread.start { s.synchronize(&blk) }
  end

  let(:critera) { subject.critera }
  let(:model) { critera.klass }

  before do
    model.create_collection_tailable!
  end

  after do
    model.collection.drop
  end

  it '#critera is .where(type: 0)' do
    expect(subject.critera.selector).to eq('type' => 0)
  end

  it '#run works' do
    logs = [
      { 'type' => 0, 'status' => [0] },
      { 'type' => 0, 'status' => [1] },
      { 'type' => 0, 'status' => [2] },
      { 'type' => 0, 'status' => [3] }
    ]
    async_with_tailable_diff do
      logs.each do |log|
        create(model.name.underscore.to_sym, log)
      end
    end
    actual = []
    catch do |catch_value|
      count = logs.size - 1
      allow(subject).to receive(:check) do |*args|
        actual.push(args.map(&:attributes_without_generated_values))
        throw catch_value if (count -= 1).zero?
      end
      subject.run
    end
    expect(actual).to eq(logs.each_cons(2).map(&:itself))
  end
end
