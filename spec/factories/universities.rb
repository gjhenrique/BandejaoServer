FactoryGirl.define do
  factory :university do
    name 'PU'
    long_name 'Programming University'
    class_name 'PUParser'

    trait :du do
      name 'DU'
      long_name 'Design University'
      class_name 'DUParser'
    end
  end
end
