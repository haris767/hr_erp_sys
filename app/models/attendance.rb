# rails create automatically when we create namespace model
module Attendance
  def self.table_name_prefix
    "attendance_"
  end
end
