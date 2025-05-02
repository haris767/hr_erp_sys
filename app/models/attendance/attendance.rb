class Attendance::Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :shift, class_name: "Attendance::Shift", foreign_key: :shift_id
  before_save :calculate_overtime
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

  private

  def calculate_overtime
    return unless check_in.present? && check_out.present? && shift.present?

    # Align shift start/end with check_in date
    shift_start = Time.zone.local(check_in.year, check_in.month, check_in.day, shift.start_time.hour, shift.start_time.min)
    shift_end = Time.zone.local(check_in.year, check_in.month, check_in.day, shift.end_time.hour, shift.end_time.min)

    # Handle overnight shift (e.g., start: 10 PM, end: 6 AM next day)
    shift_end += 1.day if shift_end <= shift_start

    scheduled_hours = ((shift_end - shift_start) / 3600.0) - shift.break_hours.to_f
    worked_hours = (check_out - check_in) / 3600.0

    self.overtime_hours = [ worked_hours - scheduled_hours, 0 ].max.round(2)
  end
end
