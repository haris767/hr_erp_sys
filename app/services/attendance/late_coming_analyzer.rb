
module Attendance
  class LateComingAnalyzer
    GRACE_PERIOD_MINUTES = 15
    MAX_ALLOWED_LATES = 3

    def initialize(attendance)
      @attendance = attendance
      @user = attendance.user
      @shift = attendance.shift
    end

    def analyze
      return unless late?

      @attendance.update!(late_status: true)

      if late_count_exceeds_limit?
        Payroll::SalaryAdjuster.new(@user).deduct_one_hour
      end
    end

    private

    def late?
      return false if @attendance.check_in.blank? || @shift.blank?

      shift_start_datetime = @attendance.attendance_date.to_datetime.change(
        hour: @shift.start_time.hour,
        min: @shift.start_time.min
      )

      grace_limit = shift_start_datetime + GRACE_PERIOD_MINUTES.minutes

      @attendance.check_in > grace_limit
    end



    def late_count_exceeds_limit?
      Attendance::Record.where(user: @user, late_status: true).count >= MAX_ALLOWED_LATES
    end
  end
end
