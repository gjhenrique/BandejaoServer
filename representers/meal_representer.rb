class MealRepresenter < Roar::Decorator
  include Roar::JSON

  property :meal_date, as: :date
  property :period, getter: ->(_) { period.name }

  collection :dishes, class: Dish do
    property :name
  end
end
