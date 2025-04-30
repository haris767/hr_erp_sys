class CreateAttendanceAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.date :attendance_date
      t.datetime :check_in
      t.datetime :check_out
      t.decimal :working_hours, precision: 5, scale: 2
      t.decimal :overtime_hours, precision: 5, scale: 2
      t.string :status
      t.boolean :payroll_processed

      t.timestamps
    end
  end
end
