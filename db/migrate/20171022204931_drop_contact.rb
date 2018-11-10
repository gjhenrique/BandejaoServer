# frozen_string_literal: true

class DropContact < ActiveRecord::Migration
  def change
    drop_table :contacts
  end
end
