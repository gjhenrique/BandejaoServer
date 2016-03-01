helpers do
  def group_meals_by_date(meals)
    grouped_meals = meals.group_by(&:meal_date)

    grouped_meals.each do |meal_date, list_meals|
      list_meals.sort! { |meal| meal.period.index }
    end
  end
end
