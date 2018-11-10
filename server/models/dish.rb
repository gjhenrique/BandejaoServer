# frozen_string_literal: true

class Dish < ActiveRecord::Base
  belongs_to :meal
end
