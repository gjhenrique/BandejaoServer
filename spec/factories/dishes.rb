# frozen_string_literal: true

FactoryBot.define do
  factory :dish do
    sequence(:name) { |n| "Dish #{n}" }

    trait :rice do
      name { 'Rice' }
    end
  end
end
