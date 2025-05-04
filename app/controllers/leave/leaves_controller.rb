
  class Leave::LeavesController < ApplicationController
    before_action :authenticate_user!

    def index
      @leaves = Leave::Leave.includes(:user, :leave_type).all
      # @leave_balances = Leave::LeaveBalance.includes(:user, :leave_type).all
    end
    def new
      @leave = Leave.new
      @leave_types = LeaveType.all
    end

    def create
      result = Leave::ApplyLeave.call(
        user: current_user,
        leave_type_id: params[:leave][:leave_type_id],
        start_date: params[:leave][:start_date],
        end_date: params[:leave][:end_date],
        reason: params[:leave][:reason]
      )

      if result.success?
        redirect_to some_dashboard_path, notice: "Leave request submitted."
      else
        @leave = Leave.new(leave_params)
        @leave.errors.add(:base, result.error)
        @leave_types = LeaveType.all
        render :new
      end
    end

    def edit
      @leave = Leave::Leave.find(params[:id])
      @leave_types = LeaveType.all
    end

    def update
      @leave = Leave::Leave.find(params[:id])
      if @leave.update(leave_params)
        redirect_to some_dashboard_path, notice: "Leave updated successfully."
      else
        @leave_types = LeaveType.all
        render :edit
      end
    end


    def show
        @leave = Leave::Leave.find(params[:id])
    end


    def approve
      leave = Leave.find(params[:id])
      leave.update(status: "Approved")
      update_leave_balance(leave)
      redirect_to admin_leaves_path, notice: "Leave approved and balance updated."
    end

    def reject
      leave = Leave.find(params[:id])
      leave.update(status: "Rejected")
      redirect_to admin_leaves_path, notice: "Leave rejected."
    end

    def destroy
      @leave = Leave::Leave.find(params[:id])
      @leave.destroy
      redirect_to leave_leaves_path, notice: "Leave request deleted successfully."
    end

    def balances
      @leave_balances = Leave::LeaveBalance.includes(:user, :leave_type).all
    end

    private

    def leave_params
      params.require(:leave).permit(:leave_type_id, :start_date, :end_date, :reason)
    end

    def update_leave_balance(leave)
      balance = LeaveBalance.find_by(user: leave.user, leave_type: leave.leave_type)
      days = (leave.end_date - leave.start_date).to_i + 1
      balance.update(remaining: balance.remaining - days)
    end
  end
