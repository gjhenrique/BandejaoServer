# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :universities do
      primary_key :id
      column :long_name, String, null: false
      column :name, String, null: false
      column :website
    end
  end
end
