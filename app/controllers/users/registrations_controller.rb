class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  layout :select_layout

  def admin_dashboard
    if current_user
      if current_user.roles.exists?(name: "Admin")
        # Admin dashboard data
        @total_employees = User.count
        @total_attendances = Attendance::Attendance.count rescue 0
        @total_leaves = Leave.count rescue 0
        # @total_salary = Payroll.sum(:net_pay) rescue 0

        # For charts (example setup)
        # @salary_by_month = Payroll.group_by_month(:created_at).sum(:net_pay)
        @employee_by_unit = User.group(:department_id).count
        render "dashboards/admin_dashboard"
        # redirect_to admin_user_list_path
      else
        set_employee_dashboard_data
        render "dashboards/employee_dashboard"
      end
    else
      redirect_to new_user_session_path
    end
  end

  def employee_dashboard
      if current_user
        @user = current_user
        # Employee dashboard data (you can customize this more)
        @leaves_taken = current_user.leaves.count rescue 0
        @total_attendances = Attendance::Attendance.for_user(current_user.id).count
        @latest_salary = current_user.payrolls.last&.net_pay rescue 0
        render "dashboards/employee_dashboard"
      else
        redirect_to new_user_session_path
      end
  end

  #  #with name,email and role based search
  def index
      if params[:query].present?
        query = "%#{params[:query]}%"
        @users = User.joins(:roles)
                  .where("users.name ILIKE :query OR users.email ILIKE :query OR roles.name ILIKE :query", query: query)
                  .distinct

      else
        @users = User.all
      end
  end


  def new
    redirect_to new_user_session_path
  end

  # GET /users/new (custom admin form)
  def new_user
    @user = User.new
    @user.build_user_info  # You need to make sure this is set up to build the associated user_info.
    @user.job_employments.build  # <-- use `.build`, because it's a has_many
    @user.asset_details.build   # <-- use `.build`, because it's a has_many
    @user.bank_details.build    # <-- use `.build`, because it's a has_many
  end

  # POST /users/create (custom admin create)
  def create_user
    @user = User.new(sign_up_params)
    if @user.save


       redirect_to admin_user_list_path, notice: "User created successfully."

    else
      render :new_user

    end
  end


  # GET /profile
  def show
     @user = current_user
  end

# GET /users/:id/edit_user (custom admin edit)
def edit
  @user = User.find(params[:id])
  @user.build_user_info if @user.user_info.blank?
  @user.bank_details.build if @user.bank_details.blank?
  @user.job_employments.build if @user.job_employments.blank?
  @user.asset_details.build if @user.asset_details.blank?
end

# PUT /users/:id/update_user (custom admin update)
def update
  @user = User.find(params[:id])

  if @user.update(sign_up_params)
    redirect_to admin_user_list_path, notice: "User updated successfully."
  else
    render :edit
  end
end



  # DELETE /users
  def destroy
    user = User.find_by(id: params[:id]) # Find the user by ID
    if user == current_user
      flash[:alert] = "You cannot delete your own account."
      redirect_to root_path
    else
      user.destroy
      flash[:notice] = "User account successfully deleted."
      redirect_to root_path # or wherever you want to redirect after deletion
    end
  end



  private

  def select_layout
    if action_name.in?(%w[new create])
      "signup" # for signup
    else
      "application" # ✅ Use AdminLTE layout for everything else
    end
  end
  def set_employee_dashboard_data
    @user = current_user
    @leaves_taken = current_user.leaves.count rescue 0
    @latest_salary = current_user.payrolls.last&.net_pay rescue 0
  end


  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :department_id, :name, :active, role_ids: [],
    user_info_attributes: [ :id, :father_name, :gender, :grade, :national_id, :dob, :phone, :personal_number, :company_number, :employee_code, :address, :profile_picture ],
    job_employments_attributes: [ :employment_type, :job_title, :hire_date, :work_location, :manager_name, :job_status, :blood_group, :employee_service ],
    asset_details_attributes: [ :id, :name, :model, :brand, :serial_number, :assigned_date, :returned_date, :status, :notes ],
    bank_details_attributes: [ :id, :salary_structure, :payment_method, :bank_name, :bank_account_number, :payroll_group_id, :_destroy ],
    )
  end
end
