FactoryGirl.define do
  factory :log do
    initialize_with { new(attributes) }
    factory :log_sw_cert do
      type 'sw_cert'
    end
  end
end
