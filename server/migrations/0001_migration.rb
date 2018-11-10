# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :periods do
      primary_key :id
      String :name
      Time :created_at
      Time :updated_at
    end

    create_table :universities do
      primary_key :id
      String :long_name
      String :name
      String :class_name
      Time :created_at
      Time :updated_at
      String :website
      foreign_key :university_id, index: true
    end

    create_table :meals do
      primary_key :id
      Date :meal_date
      Time :created_at
      Time :updated_at
      foreign_key :period_id, index: true
      foreign_key :univerisity, index: true
    end

    create_table :dishes do
      primary_key :id
      String :name
      Time :created_at
      Time :updated_at
      foreign_key :meal_id, index: true
    end
  end

  down do
    drop_table :periods
    drop_table :universities
    drop_table :meals
    drop_table :dishes
  end
end
