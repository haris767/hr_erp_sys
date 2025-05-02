class AddLateStatusToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_column :attendance_attendances, :late_status, :boolean, default: false
  end
end
