class CreateLeaves < ActiveRecord::Migration[8.0]
  def change
    create_table :leaves do |t|
      t.references :user, null: false, foreign_key: true
      t.references :leave_type, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.text :reason
      t.string :status, default: "Pending"

      t.timestamps
    end
  end
end
