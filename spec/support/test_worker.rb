require 'honeypot/workable'

class TestWorker
  include Honeypot::Workable

  def critera
    ::TestModel.where(type: 0)
  end

  def check(*)
  end
end
