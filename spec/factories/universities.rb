# frozen_string_literal: true

FactoryBot.define do
  factory :university do
    name { 'PU' }
    long_name { 'Programming University' }
    class_name { 'PUParser' }
    website { 'http://pu.org' }

    trait :du do
      name { 'DU' }
      long_name { 'Design University' }
      class_name { 'DUParser' }
    end
  end
end
