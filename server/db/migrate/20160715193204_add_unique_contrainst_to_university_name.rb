# frozen_string_literal: true

class AddUniqueContrainstToUniversityName < ActiveRecord::Migration
  def change
    add_index :universities, :name, unique: true
  end
end
