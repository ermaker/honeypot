require 'mongoid'

module Honeypot
  # The Container for anything
  class Log
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
      ).tap do
        create
      end
    rescue Moped::Errors::OperationFailure => e
      raise unless e.details[:errmsg] == 'collection already exists'
      raise unless collection.capped?
    end
  end
end
