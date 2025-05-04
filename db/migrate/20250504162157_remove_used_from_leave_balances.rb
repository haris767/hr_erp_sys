class RemoveUsedFromLeaveBalances < ActiveRecord::Migration[8.0]
  def change
    remove_column :leave_balances, :used, :decimal
  end
end
