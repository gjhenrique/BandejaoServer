require 'gcm'

class ParserJob
  def self.parse_all
    University.find_campus.each { |university| parse_university university }
  end

  def self.parse_university(university)
    klass = university.class_name.constantize
    parser = klass.new
    log = ParserLogger.new(university)

    synchronizer = MealSynchronizer.new university, parser, log
    new_meals = synchronizer.sync_meals
    return if new_meals.nil?

    ActiveRecord::Base.transaction do
      new_meals.map(&:save)
    end

    send_gcm_request university.main_name.downcase, log
    send_gcm_request 'all', log
  end

  def self.send_gcm_request(topic, logger)
    gcm_key = ENV['GCM_KEY']
    gcm = GCM.new(gcm_key)
    response_gcm = gcm.send_with_notification_key("/topics/#{topic}",
                                                  data: { message: 'UPDATE' })
    logger.info response_gcm
  end
end
