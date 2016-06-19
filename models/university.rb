class University < ActiveRecord::Base
  belongs_to :university
  has_many :universities

  def self.random
    order('RANDOM()')
  end

  def has_campus?
    !universities.empty?
  end

  def campus?
    !university.nil?
  end

  def main_name
    if university.nil?
      university.name
    else
      university.university.name
    end
  end

  def self.by_name(name)
    where('LOWER(name) = ?', name.downcase).first
  end

  def self.find_campus
    where.not(id: University.select(:university_id).where.not(university_id: nil).uniq)
  end

  def self.without_campus
    where(university_id: nil)
  end
end
