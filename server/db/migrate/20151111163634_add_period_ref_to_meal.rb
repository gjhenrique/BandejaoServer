# frozen_string_literal: true

class AddPeriodRefToMeal < ActiveRecord::Migration
  def change
    add_reference :meals, :period, index: true, foreign_key: true
  end
end
