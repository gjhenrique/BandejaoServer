# Calss the parser from the university and compares with persisted weekly meals
class ParserJob
  def self.perform(university_id)

    university = University.find(university_id)
    klass = university.class_name.constantize
    html_meals = klass.parse

    return if html_meals.nil?

    # Gettings meals only for this week
    html_meals.select! { |meal| (meal.meal_date + 1).cweek == (DateTime.now + 1).cweek }
    html_meals.each { |m| m.university = university }

    weekly_meals = Meal.weekly(university)
    new_meals = meals_difference(html_meals, weekly_meals)
    return if new_meals.empty?

    ActiveRecord::Base.transaction do
      new_meals.map(&:save)
    end
  end

  # Function here to don't monkey patch the array function
  def self.meals_difference(meals, other_meals)
    meals_struct = meals.map(&:to_struct)
    other_meals_struct = other_meals.map(&:to_struct)
    (meals_struct - other_meals_struct).map(&:to_model)
  end
end
