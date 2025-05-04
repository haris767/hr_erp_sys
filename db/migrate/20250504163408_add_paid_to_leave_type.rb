class AddPaidToLeaveType < ActiveRecord::Migration[8.0]
  def change
    add_column :leave_types, :paid, :boolean, default: false
  end
end
