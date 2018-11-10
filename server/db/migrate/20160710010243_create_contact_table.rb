# frozen_string_literal: true

class CreateContactTable < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :info

      t.timestamps null: false
    end
  end
end
