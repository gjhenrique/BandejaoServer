# frozen_string_literal: true

class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.date :meal_date

      t.timestamps null: false
    end
  end
end
