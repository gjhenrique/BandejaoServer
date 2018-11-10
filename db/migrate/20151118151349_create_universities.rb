# frozen_string_literal: true

class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name
      t.string :long_name
      t.string :class_name

      t.timestamps null: false
    end
  end
end
