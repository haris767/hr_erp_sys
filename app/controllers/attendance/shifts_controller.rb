class Attendance::ShiftsController < ApplicationController
  before_action :set_shift, only: %i[edit update destroy]

  def index
    @shifts = Attendance::Shift.all
  end

  def new
    @shift = Attendance::Shift.new
  end

  def create
    @shift = Attendance::Shift.new(shift_params)
    if @shift.save
      redirect_to attendance_shifts_path, notice: "Shift created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @shift.update(shift_params)
      redirect_to attendance_shifts_path, notice: "Shift updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @shift.destroy
    redirect_to attendance_shifts_path, notice: "Shift deleted successfully."
  end

  private

  def set_shift
    @shift = Attendance::Shift.find(params[:id])
  end

  def shift_params
    params.require(:attendance_shift).permit(:name, :start_time, :end_time, :break_hours, :is_rotating, :shift_type)
  end
end
