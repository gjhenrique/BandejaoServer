require 'gcm'

# Calls the parser from the university and compares with persisted weekly meals
class ParserJob
  def self.parse_all
    University.all_campus.each { |university| parse_university university }
  end

  def self.parse_university(university)
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

    send_gcm university.name
  end

  # Function in the ParserJob class to don't need to monkey patch the array function
  def self.meals_difference(meals, other_meals)
    meals_struct = meals.map(&:to_struct)
    other_meals_struct = other_meals.map(&:to_struct)
    (meals_struct - other_meals_struct).map(&:to_model)
  end

  def self.send_gcm(topic)
    file_path = Sinatra::Application.settings.root + '/config/gcm.yml'
    gcm_file = YAML.load(File.read(file_path))
    gcm = GCM.new(gcm_file['key'])
    gcm.send_with_notification_key("/topics/#{topic}",
                                   data: { message: 'UPDATE' })
  end
end
