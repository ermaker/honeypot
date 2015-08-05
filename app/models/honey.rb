require 'mongoid'

module Honeypot
  # The Container for anything
  class Honey
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include Mongoid::Timestamps::Created::Short

    # @return [Hash] Attributes except '_id'
    def attributes_without_id
      attributes.reject { |k, _| k == '_id' }
    end
  end
end
