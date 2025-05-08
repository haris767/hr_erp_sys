class Attendance::Shift < ApplicationRecord
  # Future association (we'll add after Attendance update)
  has_many :attendances, class_name: "Attendance::Attendance", foreign_key: :shift_id
  # user association for get specific user shift
  has_many :user_shifts, class_name: "Attendance::UserShift"
  has_many :users, through: :user_shifts


  validates :name, presence: true, uniqueness: true
  validates :start_time, :end_time, presence: true
  validates :break_hours, numericality: { greater_than_or_equal_to: 0 }

  enum :shift_type, {
    Regular: "Regular",
    Overtime: "Overtime",
    On_call: "On-call"
  }

  def absenteeism_percentage
    total_employees = User.count  # or filter based on assignment logic later
    attended_users = attendances.select(:user_id).distinct.count

    missed = total_employees - attended_users
    return 0 if total_employees.zero?

    ((missed.to_f / total_employees) * 100).round(2)
  end
end
