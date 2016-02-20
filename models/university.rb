class University < ActiveRecord::Base
  def self.random
    order('RANDOM()').first
  end
end
