class Leave::LeaveType < ApplicationRecord
  has_many :leaves, class_name: "Leave::Leave"
  has_many :leave_balances, class_name: "Leave::LeaveBalance"

  validates :name, presence: true, uniqueness: true
end
