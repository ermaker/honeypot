require 'honeypot/workable'

class TestWorker # rubocop:disable Style/Documentation
  include Honeypot::Workable

  def critera
    ::TestModel.where(type: 0)
  end

  def check(*)
  end
end
