class Attendance::UserShift < ApplicationRecord
  belongs_to :user
  belongs_to :shift, class_name: "Attendance::Shift"
  # validates :assigned_on, presence: true
end
