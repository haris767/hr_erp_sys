class CreateAttendanceShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_shifts do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.decimal :break_hours, precision: 4, scale: 2, default: 1.0
      t.boolean :is_rotating, default: false
      t.string :shift_type, default: 'Regular'

      t.timestamps
    end
  end
end
