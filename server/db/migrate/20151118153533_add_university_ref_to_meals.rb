# frozen_string_literal: true

class AddUniversityRefToMeals < ActiveRecord::Migration
  def change
    add_reference :meals, :university, index: true, foreign_key: true
  end
end
