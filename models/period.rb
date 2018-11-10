# frozen_string_literal: true

class Period < ActiveRecord::Base
  def self.breakfast
    where(name: 'BREAKFAST').first
  end

  def self.lunch
    where(name: 'LUNCH').first
  end

  def self.vegetarian_lunch
    where(name: 'VEGETARIAN LUNCH').first
  end

  def self.dinner
    where(name: 'DINNER').first
  end

  def self.vegetarian_dinner
    where(name: 'VEGETARIAN DINNER').first
  end

  # Lunch and Dinner
  def self.both
    where(name: 'BOTH').first
  end

  def index
    case name
    when 'BREAKFAST'
      -1
    when 'LUNCH'
      0
    when 'VEGETARIAN LUNCH'
      + 1
    when 'DINNER'
      +2
    when 'VEGETARIAN DINNER'
      +3
    when 'BOTH'
      +4
    end
  end

  def to_s
    name
  end
end
