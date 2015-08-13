require 'honeypot/workerable'

class TestWorker # rubocop:disable Style/Documentation
  include Honeypot::Workerable

  def critera
    ::TestModel.where(type: 0)
  end

  def check(*)
  end
end
