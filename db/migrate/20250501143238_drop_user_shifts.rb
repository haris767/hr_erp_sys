class DropUserShifts < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_shifts
  end
end
