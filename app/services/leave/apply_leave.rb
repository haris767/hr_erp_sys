
  class Leave::ApplyLeave
    def self.call(user:, leave_type_id:, start_date:, end_date:, reason:)
      leave_type = LeaveType.find_by(id: leave_type_id)
      return failure("Invalid leave type") unless leave_type

      balance = LeaveBalance.find_by(user: user, leave_type: leave_type)
      return failure("No leave balance available") unless balance

      days_requested = (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
      if balance.remaining < days_requested
        return failure("Insufficient leave balance")
      end

      leave = Leave.create(
        user: user,
        leave_type: leave_type,
        start_date: start_date,
        end_date: end_date,
        reason: reason,
        status: "Pending"
      )

      leave.persisted? ? success(leave) : failure("Leave creation failed")
    end

    def self.success(data)
      OpenStruct.new(success?: true, data: data)
    end

    def self.failure(error)
      OpenStruct.new(success?: false, error: error)
    end
  end
