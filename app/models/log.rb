# The Log model
class Log
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created::Short
  include Tailable

  def self.recent(*where)
    where(*where).desc('c_at').limit(1)
  end
end
