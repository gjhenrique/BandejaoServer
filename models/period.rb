class Period < ActiveRecord::Base

  def self.breakfast
    where(name: 'BREAKFAST').first
  end

  def self.lunch
    where(name: 'LUNCH').first
  end

  def self.dinner
    where(name: 'DINNER').first
  end

  def self.both
    where(name: 'BOTH').first
  end

  def index
    case name
    when 'BREAKFAST'
      -1
    when 'LUNCH'
      0
    when 'DINNER'
      +1
    when 'BOTH'
      +2
    end
  end
end
