class Attendance::AttendancesController < ApplicationController # namespace use controller/attendance/attendances_controller.rb
  before_action :authenticate_user!
  before_action :set_attendance, only: %i[show edit update destroy]

  # def index
  #   @attendances = Attendance::Attendance.includes(:user).order(attendance_date: :desc)
  # end

  def index
    @users = User.all

    @attendances = Attendance::Attendance.includes(:user)

    # Filter by user if selected
    @attendances = @attendances.where(user_id: params[:user_id]) if params[:user_id].present?

    # Apply sorting based on selected param
    case params[:sort]
    when "working_hours"
      @attendances = @attendances.order(working_hours: :desc)
    when "status"
      @attendances = @attendances.order(status: :asc)
    else
      @attendances = @attendances.order(attendance_date: :desc)  # default
    end
  end


  def show
  end

  def new
    @attendance = Attendance::Attendance.new
  end

  def create
    @attendance = Attendance::Attendance.new(attendance_params)
    if @attendance.save
      redirect_to attendance_attendance_path(@attendance), notice: "Attendance created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @attendance.update(attendance_params)
      redirect_to attendance_attendance_path(@attendance), notice: "Attendance updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to attendance_attendances_path, notice: "Attendance deleted successfully."
  end

  private

  def set_attendance
    @attendance = Attendance::Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance_attendance).permit(
      :user_id, :attendance_date, :check_in, :check_out,
      :working_hours, :overtime_hours, :status, :payroll_processed
    )
  end
end
