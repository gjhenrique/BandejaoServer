# frozen_string_literal: true

FactoryBot.define do
  factory :meal do
    meal_date { DateTime.now.monday }

    period { Period.lunch || association(:period, :lunch) }

    university { University.where(name: build(:university).name).first || association(:university) }

    trait :previous_saturday do
      meal_date { DateTime.now.monday - 2 }
    end

    trait :monday do
      meal_date { DateTime.now.monday }
      updated_at { DateTime.now.monday }
    end

    trait :sunday do
      meal_date { DateTime.now.monday - 1 }
    end

    trait :outdated_monday do
      meal_date { DateTime.now.monday }
      updated_at { DateTime.now.monday - 1 }
    end

    trait :this_saturday do
      meal_date { DateTime.now.monday + 5 }
    end

    trait :monday_dinner do
      meal_date { DateTime.now.monday }
      period { Period.dinner || association(:period, :dinner) }
    end

    trait :next_monday do
      meal_date { DateTime.now.monday + 7 }
    end

    trait :meals_with_fake_dishes do
      after(:create) do |meal, _evaluator|
        create_list(:dish, 5, meal: meal)
      end
    end

    trait :one_dish do
      after(:build) do |meal, _evaluator|
        meal.dishes << build(:dish, :rice)
      end
    end

    trait :one_fake_dish do
      after(:build) do |meal, _evaluator|
        meal.dishes << build(:dish)
      end
    end

    trait :end_of_year do
      meal_date { Date.strptime('2015-12-27', '%Y-%m-%d') }
    end

    trait :beginning_of_year do
      meal_date { Date.strptime('2016-01-02', '%Y-%m-%d') }
    end
  end
end
