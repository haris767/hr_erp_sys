class Attendance::UserShiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_shift, only: [ :edit, :update, :destroy ]
  before_action :set_users_and_shifts, only: [ :new, :create, :edit, :update ]

  def index
    @user_shifts = Attendance::UserShift.includes(:user, :shift).order(created_at: :desc)
  end

  def new
    @user_shift = Attendance::UserShift.new
    @users = User.all # Fetch all users
    @shifts = Attendance::Shift.all # Fetch all shifts
  end

  def create
    @user_shift = Attendance::UserShift.new(user_shift_params)
    if @user_shift.save
      redirect_to attendance_user_shifts_path, notice: "Shift assigned successfully."
    else
      flash.now[:alert] = @user_shift.errors.full_messages.to_sentence
      @users = User.all
      @shifts = Attendance::Shift.all
      render :new
    end
  end


  def edit
    @user_shift = Attendance::UserShift.find(params[:id])
  end

  def update
    @user_shift = Attendance::UserShift.find(params[:id])
    if @user_shift.update(user_shift_params)
      redirect_to attendance_user_shifts_path, notice: "Shift updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @user_shift.destroy
    redirect_to attendance_usershifts_path, notice: "Shift assignment removed."
  end

  private

  def set_user_shift
    @user_shift = Attendance::UserShift.find(params[:id])
  end

  def set_users_and_shifts
    @users = User.all
    @shifts = Attendance::Shift.all
  end

  def user_shift_params
    params.require(:attendance_user_shift).permit(:user_id, :shift_id)
  end
end
