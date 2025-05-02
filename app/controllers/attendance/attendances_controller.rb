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

  def shift_report
    @shifts = Attendance::Shift.all

    if params[:shift_id].present?
      @shift = Attendance::Shift.find(params[:shift_id])
      @attendances = @shift.attendances.includes(:user)
    else
      @attendances = []
    end

    respond_to do |format|
      format.html
      format.csv do
        headers["Content-Disposition"] = "attachment; filename=shift_#{@shift&.name || 'report'}_report.csv"
        render csv: generate_csv(@attendances)
      end
      format.pdf do
        pdf = generate_pdf(@attendances)
        send_data pdf.render, filename: "shift_#{@shift&.name || 'report'}_report.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  require "csv"

  def overtime_analysis
    @top_employees = Attendance::OvertimeAnalyzer.top_overtime_employees
    @current_user_total = Attendance::OvertimeAnalyzer.total_overtime_for_user(current_user, 1.month.ago, Time.now)
  end

  private

  def set_attendance
    @attendance = Attendance::Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance_attendance).permit(
      :user_id, :attendance_date, :check_in, :check_out,
      :working_hours, :overtime_hours, :status, :shift_id, :payroll_processed
    )
  end

  def generate_csv(attendances)
    CSV.generate(headers: true) do |csv|
      csv << [ "User Name", "Date", "Check-in", "Check-out" ]
      attendances.each do |a|
        csv << [
          a.user.full_name,
          a.date.strftime("%d-%m-%Y"),
          a.check_in&.strftime("%I:%M %p"),
          a.check_out&.strftime("%I:%M %p")
        ]
      end
    end
  end

  def generate_pdf(attendances)
    Prawn::Document.new do |pdf|
      pdf.text "Shift Attendance Report", size: 18, style: :bold
      pdf.move_down 10

      if attendances.any?
        table_data = []
        table_data << [ "User Name", "Date", "Check-in Time", "Check-out Time" ]

        attendances.each do |a|
          user_name = a.user&.name || "N/A"
          date = a.attendance_date&.strftime("%d-%m-%Y") || "N/A"
          check_in = a.check_in&.strftime("%I:%M %p") || "N/A"
          check_out = a.check_out&.strftime("%I:%M %p") || "N/A"

          table_data << [ user_name, date, check_in, check_out ]
        end

        pdf.table(table_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ])
      else
        pdf.text "No attendance records found for this shift.", style: :italic
      end
    end
  end
end
