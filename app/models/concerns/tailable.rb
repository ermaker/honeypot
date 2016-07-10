# The concern for capped collection of mongodb
module Tailable
  extend ActiveSupport::Concern

  module ClassMethods # rubocop:disable Style/Documentation
    def create_collection_tailable! # rubocop:disable Metrics/AbcSize
      mongo_client.command(
        create: collection_name.to_s, capped: true,
        size: 20 * 1024 * 1024
      ).tap { create }
    rescue Mongo::Error::OperationFailure => e
      raise unless e.message.start_with? 'collection already exists'
      unless collection.capped?
        collection.drop
        retry
      end
    end
  end
end
