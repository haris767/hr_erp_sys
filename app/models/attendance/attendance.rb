class Attendance::Attendance < ApplicationRecord
  belongs_to :user

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
end
