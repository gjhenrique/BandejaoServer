require 'gcm'

# Calls the parser from the university and compares with persisted weekly meals
class ParserJob
  def self.parse_all
    University.find_campus.each { |university| parse_university university }
  end

  def self.parse_university(university)
    log = ParserLogger.new(university)

    klass = university.class_name.constantize

    begin
      html_meals = klass.parse
    rescue StandardError => e
      puts "Error during processing: #{e.inspect}"
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      # log.save_file klass.resource
      return
    end

    if html_meals.nil?
      log.info 'Meals are nil'
      # log.save_file klass.resource
      return
    end

    # Gettings meals only for this week
    html_meals.select! { |meal| (meal.meal_date + 1).cweek == (DateTime.now + 1).cweek }
    html_meals.each { |m| m.university = university }

    weekly_meals = Meal.weekly(university)
    new_meals = meals_difference(html_meals, weekly_meals)

    if new_meals.empty?
      log.info 'No difference'
      return
    end

    log.info 'A'
    log.info "New Meals #{new_meals}"
    #log.save_file klass.resource

    ActiveRecord::Base.transaction do
      new_meals.map(&:save)
    end

    log.info "Gcm to university #{university.name}"
    university_name = if university.is_campus?
                        university.university.name
                      else
                        university.name
                      end
    send_gcm university_name
    send_gcm 'All'
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
    #gcm.send_with_notification_key("/topics/#{topic}",
    #                               data: { message: 'UPDATE' })
  end
end

class ParserLogger

  DIR_LOG = "#{Sinatra::Application.root}/log/parsers"
  def initialize(university)
    @university = university
    FileUtils.mkdir_p(dir_LOG) unless File.directory?(DIR_LOG)
    @logger = Logger.new("#{DIR_LOG}/#{university.name}.log")
    @logger.level = Logger::INFO
    @logger.formatter = proc do |severity, datetime, _, msg|
      date_format = datetime.strftime '%Y-%m-%d %H:%M:%S'
      "[#{date_format}] #{severity}: #{msg}\n"
    end
  end

  def method_missing(m, *args, &_)
    @logger.send(m, args[0])
  end

  # TODO: Implement this
  def save_file(content)
  end
end
