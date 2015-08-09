require 'honeypot/sw_cert'
require 'models/log'

RSpec.describe Honeypot::SWCert do
  let(:model) { subject.critera.klass }
  let(:logs) do
    [
      { status: [] },
      { status: [] },
      { status: [1] },
      { status: [1] }
    ].map do |log|
      model.new(log)
    end
  end

  describe '#notify_if_modified' do
    it 'works' do
      expect(subject.notify_if_modified(logs[0], logs[1])).to be(false)
      expect(subject.notify_if_modified(logs[1], logs[2])).to be(true)
      expect(subject.notify_if_modified(logs[2], logs[3])).to be(false)
    end
  end

  it '#critera works' do
    expect(subject.critera).to eq(Honeypot::Log.where(type: 'sw_cert'))
  end
end
