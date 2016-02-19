FactoryGirl.define do
  factory :dish do
    sequence(:name) { |n| "Dish #{n}" }

    trait :rice do
      name 'Rice'
    end
  end
end
