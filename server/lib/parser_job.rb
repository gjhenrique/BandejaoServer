# frozen_string_literal: true

require 'gcm'

class ParserJob
  DEFAULT_UNIVERSITY_CLASS = 'Parser::%sParser'
  class << self
    def parse_all
      University.find_campus.each { |university| parse_university university }
    end

    def parse_university(university)
      App.logger.tagged('syncing', university.name) do
        parser = create_parser(university)
        new_meals = MealSynchronizer.new(university, parser).sync_meals

        return unless new_meals.present?

        process_new_meals university, new_meals
      end
    end

    private

    def create_parser(university)
      klass = university.class_name || DEFAULT_UNIVERSITY_CLASS % university.name.capitalize
      klass.constantize.new
    end

    def process_new_meals(university, new_meals)
      ActiveRecord::Base.transaction do
        new_meals.map(&:save)
      end

      # Don't send a gcm request in the development mode
      return unless App.production?

      send_gcm_request university.main_name
      send_gcm_request 'all', logger
    end

    def send_gcm_request(topic)
      gcm_key = ENV['GCM_KEY']
      gcm = GCM.new(gcm_key)
      response_gcm = gcm.send_with_notification_key("/topics/#{topic}",
                                                    data: { message: 'UPDATE' })
      App.logger.info response_gcm
    end
  end
end
