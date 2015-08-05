require 'mongoid'

module Honeypot
  # The Container for anything
  class CappedHoney
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    # @return [Hash] Attributes except '_id'
    def attributes_without_id
      attributes.reject { |k, _| k == '_id' }
    end

    def self.create_collection
      mongo_session.command(
        create: collection_name.to_s,
        capped: true,
        size: 1024
      )
      create
    end

    def self.tailable_cursor
      all.query.tailable.skip(all.size).cursor
    end

    def self.lazy_diff_cursor
      tailable_cursor.lazy.map do |_|
        desc('_id').limit(2).reverse
      end
    end
  end
end
