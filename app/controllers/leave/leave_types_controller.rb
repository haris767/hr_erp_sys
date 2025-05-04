class Leave::LeaveTypesController < ApplicationController
  before_action :set_leave_type, only: %i[edit update destroy]

  def index
    @leave_types = Leave::LeaveType.all
  end

  def new
    @leave_type = Leave::LeaveType.new
  end

  def create
    @leave_type = Leave::LeaveType.new(leave_type_params)
    if @leave_type.save
      redirect_to leave_leave_types_path, notice: "Leave type created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @leave_type.update(leave_type_params)
      redirect_to leave_leave_types_path, notice: "Leave type updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @leave_type.destroy
    redirect_to leave_leave_types_path, notice: "Leave type deleted."
  end

  private

  def set_leave_type
    @leave_type = Leave::LeaveType.find(params[:id])
  end

  def leave_type_params
    params.require(:leave_leave_type).permit(:name, :description, :paid)
  end
end
