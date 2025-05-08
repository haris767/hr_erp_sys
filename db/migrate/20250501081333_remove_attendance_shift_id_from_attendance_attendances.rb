class RemoveAttendanceShiftIdFromAttendanceAttendances < ActiveRecord::Migration[8.0]
  def change
    remove_reference :attendance_attendances, :attendance_shift, foreign_key: true
  end
end
