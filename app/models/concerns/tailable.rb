# The concern for capped collection of mongodb
module Tailable
  extend ActiveSupport::Concern

  module ClassMethods # rubocop:disable Style/Documentation
    def create_collection # rubocop:disable Metrics/AbcSize
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
