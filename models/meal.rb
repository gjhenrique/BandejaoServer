# frozen_string_literal: true

class Meal < ActiveRecord::Base
  has_many :dishes
  belongs_to :period
  belongs_to :university

  DEFAULT_FILTER = "'+1 day',  'weekday 0', '-7 day'"

  scope :by_year, (lambda do |date|
    where("strftime('%Y', date(?, #{DEFAULT_FILTER})) = " \
          "strftime('%Y', date(meal_date, #{DEFAULT_FILTER}))",
          date.strftime('%Y-%m-%d'))
  end)

  # Sqlite uses ISO dates (begins at monday and finishes at sunday)
  # This workaround sums 1 day to fix this (begins at sunday and finishes at saturday).
  scope :by_week, (lambda do |date|
                     where("strftime('%W', date(?, #{DEFAULT_FILTER})) = " \
                           "strftime('%W', date(meal_date, #{DEFAULT_FILTER}))",
                           date.strftime('%Y-%m-%d'))
                   end)

  def self.weekly(university, date = Time.now)
    by_week(date).by_year(date).filter_by_date(university, date)
  end

  def self.filter_by_date(university, _date)
    meals = where(university: university)
            .order('meal_date, period_id, updated_at DESC')
            .includes(:dishes).to_a
    meals.uniq { |meal| [meal.period_id, meal.meal_date] }
  end

  def to_s
    "{Period: #{period} <-> meal_date: #{meal_date.strftime('#%Y-%M-%d')} " \
    "<-> #{dishes&.map(&:name)}}"
  end
end
