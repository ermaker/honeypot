FactoryGirl.define do
  factory :test_model do
    initialize_with { new(attributes) }
  end
end
