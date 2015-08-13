# The Log model
class Log
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Tailable
end
