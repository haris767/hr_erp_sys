class CreateAttendanceUserShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_user_shifts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shift, null: false, foreign_key: { to_table: :attendance_shifts }
      t.date :assigned_on

      t.timestamps
    end
  end
end
