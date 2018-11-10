# frozen_string_literal: true

class AddUniversityNotNullToMeal < ActiveRecord::Migration
  def change
    change_column_null(:meals, :university_id, false)
  end
end
