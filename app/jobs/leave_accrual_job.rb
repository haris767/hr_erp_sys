# class LeaveAccrualJob < ApplicationJob
#   queue_as :default

#   def perform(*args)
#     # Calculate and add leave accrual for each employee
#     User.find_each do |user|
#       # Add leave days for the month
#       leave_type = LeaveType.find_by(name: "Annual Leave") # Replace with the leave type you're using
#       if leave_type
#         accrual_days = leave_type.accrual_per_month # You can store this value in the LeaveType model
#         Leave.create!(
#           user: user,
#           leave_type: leave_type,
#           start_date: Date.today.beginning_of_month,
#           end_date: Date.today.beginning_of_month + accrual_days.days - 1,
#           status: "Approved"
#         )
#       end
#     end
#   end
# end
