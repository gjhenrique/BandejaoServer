class AddUniversityToUniversity < ActiveRecord::Migration
  def change
    add_reference(:universities, :university, index: true)
  end
end
