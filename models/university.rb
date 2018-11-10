# frozen_string_literal: true

class University < ActiveRecord::Base
  belongs_to :university
  has_many :universities

  def self.random
    order('RANDOM()')
  end

  def self.by_name(name)
    where('LOWER(name) = ?', name.downcase).first
  end

  def self.find_campus
    where.not(id: University.select(:university_id)
         .where.not(university_id: nil).uniq)
  end

  def eql?(other)
    other.name == name
  end

  # TODO: Check this
  def has_campus?
    universities.present?
  end

  def campus?
    university.present?
  end

  def main_name
    (university.try(:name) || name).downcase
  end

  def hash
    name.hash
  end
end
