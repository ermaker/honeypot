class TestModel # rubocop:disable Style/Documentation
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Tailable
  field :type, type: Integer
  field :value, type: Integer

  GENERATED_KEYS = %w(_id c_at)

  # @return [Hash] Attributes except '_id' and 'c_at'
  def attributes_without_generated_values
    attributes.reject { |k, _| GENERATED_KEYS.include?(k) }
  end
end
