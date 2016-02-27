helpers do
  def setup_meals(weekly_meals)
    grouped_meals = weekly_meals.group_by(&:meal_date).values

    grouped_meals.each do |day_meals|
      day_meals.sort! { |meal| meal.period.index }
    end
  end
end
