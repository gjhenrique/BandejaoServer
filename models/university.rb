class University < ActiveRecord::Base
  belongs_to :university
  has_many :universities

  def self.random
    order('RANDOM()').first
  end

  def has_campus?
    universities.size > 0
  end

  def is_campus?
    university != nil
  end

  def self.by_name(name)
    where('LOWER(name) = ?', name.downcase).first
  end

  def self.all_campus
    where.not(id: University.select(:university_id).where.not(university_id: nil).uniq)
  end
end
