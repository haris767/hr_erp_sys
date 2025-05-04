class CreateLeaveBalances < ActiveRecord::Migration[8.0]
  def change
    create_table :leave_balances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :leave_type, null: false, foreign_key: true
      t.decimal :total
      t.decimal :used
      t.decimal :remaining

      t.timestamps
    end
  end
end
