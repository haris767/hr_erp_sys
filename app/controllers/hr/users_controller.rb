class Hr::UsersController < ApplicationController
  def index
    if params[:query].present?
      @users = User.where("name ILIKE ?", "%#{params[:query]}%")
                   .or(User.where("email ILIKE ?", "%#{params[:query]}%"))  # Search by email too

      if @users.empty?
        flash.now[:alert] = "No users found with that name or email."
      end
    else
      @users = User.all
    end
  end
end
