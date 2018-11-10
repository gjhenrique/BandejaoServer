# frozen_string_literal: true

class UniversityRepresenter < Roar::Decorator
  include Roar::JSON

  property :name
  property :website
  property :long_name
end
