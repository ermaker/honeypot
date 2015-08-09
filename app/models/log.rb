require 'mongoid'

module Honeypot
  # The Container for anything
  class Log
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include Mongoid::Timestamps::Created::Short

    GENERATED_KEYS = %w(_id c_at)

    # @return [Hash] Attributes except '_id' and 'c_at'
    def attributes_without_generated_values
      attributes.reject { |k, _| GENERATED_KEYS.include?(k) }
    end

    def self.create_collection
      mongo_session.command(
        create: collection_name.to_s,
        capped: true,
        size: 20 * 1024 * 1024
      ).tap do
        create
      end
    rescue Moped::Errors::OperationFailure => e
      raise unless e.details[:errmsg] == 'collection already exists'
      raise unless collection.capped?
    end
  end
end
