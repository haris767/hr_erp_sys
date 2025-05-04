class Leave::LeaveBalance < ApplicationRecord
  belongs_to :user
  belongs_to :leave_type, class_name: "Leave::LeaveType"

  validates :total, :remaining, presence: true

  def used_leaves
    user.leaves
        .where(status: "approved", leave_type_id: leave_type_id)
        .sum("DATE_PART('day', end_date - start_date) + 1")
  end

  def remaining_leaves
    total_allocated - used_leaves
  end
end
