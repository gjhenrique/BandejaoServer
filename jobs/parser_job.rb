require 'gcm'

class ParserJob
  def self.parse_all
    University.find_campus.each { |university| parse_university university }
  end

  def self.parse_university(university)
    klass = if university.class_name.nil?
              "Parser::#{university.name.capitalize}Parser"
            else
              university.class_name
            end
    parser = klass.constantize.new
    logger = ParserLogger.new(university)

    synchronizer = MealSynchronizer.new university, parser, logger
    new_meals = synchronizer.sync_meals
    return if new_meals.nil?

    process_new_meals university, new_meals, logger
  end

  def self.process_new_meals(university, new_meals, logger)
    ActiveRecord::Base.transaction do
      new_meals.map(&:save)
    end

    # Don't send a gcm request in the development mode
    if Sinatra::Application.is_production
      send_gcm_request university.main_name.downcase, logger
      send_gcm_request 'all', logger
    end
  end

  def self.send_gcm_request(topic, logger)
    gcm_key = ENV['GCM_KEY']
    gcm = GCM.new(gcm_key)
    response_gcm = gcm.send_with_notification_key("/topics/#{topic}",
                                                  data: { message: 'UPDATE' })
    logger.info response_gcm
  end
end
