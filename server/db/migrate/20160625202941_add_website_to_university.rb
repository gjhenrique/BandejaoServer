# frozen_string_literal: true

class AddWebsiteToUniversity < ActiveRecord::Migration
  def change
    add_column :universities, :website, :text
  end
end
