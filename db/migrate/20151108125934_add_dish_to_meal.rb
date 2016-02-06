class AddDishToMeal < ActiveRecord::Migration
  def change
    add_reference :dishes, :meal, index: true, foreign_key: true
  end
end
