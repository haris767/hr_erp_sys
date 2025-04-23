class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  layout :select_layout

  # def index
  #   @users = User.all
  # end
  #
  def index
    if params[:query].present?
      @users = User.where("name ILIKE :query OR email ILIKE :query", query: "%#{params[:query]}%")

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

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name
      redirect_to user_profile_path, notice: "Profile updated successfully."
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /users
  def destroy
    user = User.find(params[:id]) # Find the user by ID
    if user == current_user
      flash[:alert] = "You cannot delete your own account."
      redirect_to root_path
    else
      user.destroy
      flash[:notice] = "User account successfully deleted."
      redirect_to users_path # or wherever you want to redirect after deletion
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

  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :active)
  end

  # Allow additional fields for account update
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, :active)
  end
end
