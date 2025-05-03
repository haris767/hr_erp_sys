
  class Attendance::LateComingAnalyzer
    # Constants
    GRACE_PERIOD_MINUTES = 15  # Grace period for late check-ins (in minutes)
    MAX_ALLOWED_LATES = 3      # Maximum allowed late check-ins before a penalty

    # Initialize with an attendance record
    def initialize(attendance)
      @attendance = attendance
      @user = attendance.user
      @shift = attendance.shift
    end

    # Analyzes if the check-in is late and applies necessary actions
    def analyze
      return unless late?  # Exit if the user is not late

      # Update the attendance record with the late status
      @attendance.update!(late_status: true)

      # If the late count exceeds the limit, deduct one hour from salary
      if late_count_exceeds_limit?
        Payroll::SalaryAdjuster.new(@user).deduct_one_hour
      end
    end

    private

    # Check if the employee is late
    def late?
      # Ensure attendance check-in and shift are present
      return false if @attendance.check_in.blank? || @shift.blank?

      # Convert check_in to a Time object (only time part)
      check_in_time = @attendance.check_in

      # Get the shift start time (ensure it's a Time object)
      shift_start_time = @shift.start_time

      # Combine the date part of check_in and shift_start_time (create a datetime)
      shift_start_datetime = @attendance.attendance_date.to_datetime.change(
        hour: shift_start_time.hour,
        min: shift_start_time.min
      )

      # Calculate the grace limit (shift start time + grace period)
      grace_limit = shift_start_datetime + GRACE_PERIOD_MINUTES.minutes

      # Compare the check-in time with the grace limit to determine lateness
      check_in_time > grace_limit
    end

    # Check if the number of late check-ins exceeds the maximum allowed
    def late_count_exceeds_limit?
      Attendance::Attendance.where(user: @user, late_status: true).count >= MAX_ALLOWED_LATES
    end
  end
