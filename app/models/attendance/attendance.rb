class Attendance::Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :shift, class_name: "Attendance::Shift", foreign_key: :shift_id
  # Keep these commented out until their tables exist:
  # belongs_to :leave, optional: true
  # belongs_to :shift
  # belongs_to :biometric_log

  # Add validations or scopes here as needed
  validates :attendance_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[Present Absent Leave Holiday] }
  validates :working_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :overtime_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # SCOPES
  scope :today, -> { where(attendance_date: Date.today) }
  scope :present, -> { where(status: "Present") }
  scope :absent, -> { where(status: "Absent") }
  scope :leave, -> { where(status: "Leave") }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :by_shift, ->(shift_id) { where(shift_id: shift_id) }


  def overtime_hours
    return 0 unless check_in && check_out && shift

    total_worked = (check_out - check_in) / 3600.0  # in hours
    shift_duration = (shift.end_time - shift.start_time) / 3600.0 - shift.break_hours.to_f

    overtime = total_worked - shift_duration
    overtime.positive? ? overtime.round(2) : 0
  end
end
