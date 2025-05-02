class AddShiftToAttendanceAttendances < ActiveRecord::Migration[8.0]
  def change
    add_reference :attendance_attendances, :shift, null: true, foreign_key: { to_table: :attendance_shifts }
  end
end
