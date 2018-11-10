# frozen_string_literal: true

FactoryBot.define do
  factory :period do
    trait :breakfast do
      name { 'BREAKFAST' }
    end

    trait :lunch do
      name { 'LUNCH' }
    end

    trait :dinner do
      name { 'DINNER' }
    end

    trait :both do
      name { 'BOTH' }
    end
  end
end
