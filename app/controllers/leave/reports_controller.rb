class Leave::ReportsController < ApplicationController
  def leave_balances
    @balances = LeaveBalance.includes(:user, :leave_type).all
  end

  def trends
    @trends = Leave.group("leave_type_id").order("count_id DESC").count("id")
  end

  #Explanation:
#leave.start_date.business_days_until(leave.end_date): This calculates the business days between the start and end dates of each 
#leave request, excluding weekends and holidays.

#working_days: This dynamically calculates the number of business days in the current month, excluding weekends and any public 
#holidays defined in your initializer.

#The business_time gem will automatically exclude weekends (Saturday and Sunday) and any holidays you’ve defined in the initializer.
#You can add more holidays to the BusinessTime::Config.holidays array as needed.

  def absenteeism
    @data = User.all.map do |user|
      total_leaves = Leave.where(user: user, status: "Approved").sum do |leave|
        leave.start_date.business_days_until(leave.end_date) + 1
      end
  
      # Calculate the total number of business days in the month
      # Assuming 22 is the default, but now it will be dynamic based on current month
      first_of_month = Date.today.beginning_of_month
      last_of_month = Date.today.end_of_month
      working_days = first_of_month.business_days_until(last_of_month)
  
      absenteeism = ((total_leaves.to_f / working_days) * 100).round(2)
  
      { user: user, days: total_leaves, absenteeism: absenteeism }
    end
  end
  
  

end
