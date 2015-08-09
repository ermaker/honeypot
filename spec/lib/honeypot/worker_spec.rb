require 'honeypot/worker'
require 'honeypot/sw_cert'

RSpec.describe Honeypot::Worker do
  let(:worker) { Honeypot::SWCert.new }
  subject { described_class.new(worker) }
  let(:critera) { subject.critera }
  let(:model) { subject.critera.klass }

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

  it '#critera works' do
    expect(subject.critera).to eq(worker.critera)
  end

  it '#run works' do
    logs = [
      { 'type' => 'sw_cert', 'status' => [0] },
      { 'type' => 'sw_cert', 'status' => [1] },
      { 'type' => 'sw_cert', 'status' => [2] },
      { 'type' => 'sw_cert', 'status' => [3] }
    ]
    async_with_tailable_diff do
      logs.each do |log|
        model.create(log)
      end
    end
    actual = []
    catch do |catch_value|
      count = logs.size - 1
      allow(worker).to receive(:notify_if_modified) do |*args|
        actual.push(args.map(&:attributes_without_generated_values))
        throw catch_value if (count -= 1).zero?
      end
      subject.run
    end
    expect(actual).to eq(logs.each_cons(2).map(&:itself))
  end
end
