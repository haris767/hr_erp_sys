class CreateLeaveTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :leave_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
