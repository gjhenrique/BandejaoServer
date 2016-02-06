class Meal < ActiveRecord::Base
  has_many :dishes
  belongs_to :period
  belongs_to :university
end
