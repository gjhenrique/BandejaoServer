class AddNotNullToPeriodId < ActiveRecord::Migration
  def change
    change_column_null :meals, :period_id, false
  end
end
