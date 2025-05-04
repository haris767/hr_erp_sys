class Leave::Leave < ApplicationRecord
  belongs_to :user
  belongs_to :leave_type, class_name: "Leave::LeaveType"

  validates :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date

  STATUSES = %w[Pending Approved Rejected]

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end
end
