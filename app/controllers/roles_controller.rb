class RolesController < ApplicationController
    before_action :set_role, only: %i[show edit update destroy]

    def index
      @roles = Role.all
    end

    def show
    end

    def new
      @role = Role.new
    end

    def create
      @role = Role.new(role_params)
      if @role.save
        redirect_to roles_path, notice: "Role created successfully."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @role.update(role_params)
        redirect_to roles_path, notice: "Role updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @role.destroy
      redirect_to roles_path, notice: "Role deleted."
    end

    private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end
end
