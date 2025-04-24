class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :restrict_sign_up
  layout :select_layout

  # def index
  #   @users = User.all
  # end
  #
  # with only name or email search
  # def index
  #   if params[:query].present?
  #     @users = User.where("name ILIKE :query OR email ILIKE :query", query: "%#{params[:query]}%")

  #   else
  #     @users = User.all
  #   end
  # end
  #
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

  # GET /users/new (custom admin form)
  def new_user
    @user = User.new
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

  def restrict_sign_up
    unless user_signed_in? && current_user.has_role?(:admin)
      redirect_to root_path, alert: "Please enter correct credentials"
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :active, role_ids: [])
  end

  # Allow additional fields for account update
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, :active, role_ids: [])
  end
end
