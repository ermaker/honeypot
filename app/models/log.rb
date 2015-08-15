# The Log model
class Log
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created::Short
  include Tailable

  def self.recent(where)
    where(where).desc('c_at').limit(1).first
  end

  def sw_cert_key
    self[:status].map { |items| items[0...-1] }
  end

  def self.sw_cert_candidates
    recent(type: :sw_cert).sw_cert_key
  end
end
