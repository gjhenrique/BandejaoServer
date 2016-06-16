class MealSynchronizer
  def initialize(university, parser, logger)
    @university = university
    @parser = parser
    @log = logger
  end

  def sync_meals(meals = Meal.weekly(@university))
    begin
      html_meals = @parser.parse
    rescue StandardError => e
      @log.error "Parser error: #{e.inspect}"
      @log.error "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      @log.save_file @parser.resource
      return
    end

    if html_meals.nil?
      @log.info 'Meals are nil'
      @log.save_file @parser.resource
      return
    end

    html_meals.each { |m| m.university = @university }
    new_meals = filter_meals html_meals, meals

    if new_meals.empty?
      @log.info 'Meals are already synced'
      return
    end

    @log.info "New Meals #{new_meals}"
    new_meals
  end

  private

  # Function in the ParserJob class to don't need to monkey patch the array function
  def filter_meals(html_meals, other_meals)
    # Gettings meals only for this week
    html_meals.select! { |meal| (meal.meal_date + 1).cweek == (DateTime.now + 1).cweek }
    html_meals_struct = html_meals.map(&:to_struct)
    other_meals_struct = other_meals.map(&:to_struct)
    (html_meals_struct - other_meals_struct).map(&:to_model)
  end
end
