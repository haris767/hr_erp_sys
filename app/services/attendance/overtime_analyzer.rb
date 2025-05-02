module Attendance
  class OvertimeAnalyzer
    def self.total_overtime_for_user(user, from_date, to_date)
      attendances = ::Attendance::Attendance.where(user: user, check_in: from_date.beginning_of_day..to_date.end_of_day)
      attendances.sum(&:overtime_hours)
    end

    def self.top_overtime_employees(limit = 5)
      ::Attendance::Attendance
        .joins("INNER JOIN users ON users.id = attendance_attendances.user_id")
        .joins("INNER JOIN attendance_shifts ON attendance_shifts.id = attendance_attendances.shift_id")
        .where.not(check_in: nil, check_out: nil)
        .group("users.id, users.name")
        .select("
          users.id,
          users.name,
          SUM(
              GREATEST(
                EXTRACT(EPOCH FROM (attendance_attendances.check_out - attendance_shifts.end_time)),
                0
              ) / 3600.0
            ) AS total_overtime
        ")
        .order("total_overtime DESC")
        .limit(limit)
    end

    def self.overtime_chart_data(limit = 5)
      top_overtime_employees(limit).each_with_object({}) do |emp, result|
        result[emp.name] = emp.total_overtime.to_f.round(2)
      end
    end
  end
end
