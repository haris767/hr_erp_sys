module Payroll
  class SalaryAdjuster
    def initialize(user)
      @user = user
    end

    def deduct_one_hour
      # Placeholder logic – will be replaced when payroll is implemented
      puts "[DEBUG] Salary deduction triggered for user: #{@user.id} - #{@user.name} (1 hour deduction)"
    end
  end
end

# def deduct_one_hour
#   salary_record = Payroll::Monthly.find_by(user: @user, month: Date.today.beginning_of_month)
#   return unless salary_record

#   hourly_rate = salary_record.monthly_salary / working_hours_in_month
#   salary_record.update!(deductions: salary_record.deductions + hourly_rate)
# end
