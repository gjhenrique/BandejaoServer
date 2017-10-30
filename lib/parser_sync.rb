class MealSynchronizer
  attr_reader :university, :parser

  def initialize(university, parser)
    @university = university
    @parser = parser
  end

  def sync_meals(meals = Meal.weekly(university))
    begin
      html_meals = parser.parse
    rescue => exc
      App.logger.error "#{exc.class}, #{exc.message}, #{exc.backtrace.join "\n\t"}"
      App.save_file parser.resource
      return
    end

    if html_meals.nil?
      App.logger.info 'Meals are nil'
      App.save_file parser.resource
      return
    end

    html_meals.each { |m| m.university = university }

    new_meals = filter_meals html_meals, meals

    if new_meals.empty?
      App.logger.info 'Meals are already synced'
      return
    end

    App.logger.info "New Meals #{new_meals.map(&:to_s)}"
    new_meals
  end

  private

  # Function in the ParserJob class to don't need to monkey patch the array function
  def filter_meals(html_meals, other_meals)
    html_meals.select! { |meal| same_week?(meal.meal_date, DateTime.now) }

    html_meals_struct = html_meals.map(&method(:to_hash))
    other_meals_struct = other_meals.map(&method(:to_hash))

    (html_meals_struct - other_meals_struct).map(&method(:to_model))
  end

  def same_week?(date1, date2)
    week_number(date1) == week_number(date2)
  end

  def week_number(date)
    # +1 because we consider sunday as the beginning of the week
    (date + 1).cweek
  end

  def to_hash(meal)
    meal.attributes.except('created_at', 'updated_at', 'id')
        .merge('dishes' => meal.dishes.map(&:name))
  end

  def to_model(hash)
    dishes = hash['dishes'].map { |d| Dish.new(name: d) }
    Meal.new(hash.merge(dishes: dishes))
  end
end
