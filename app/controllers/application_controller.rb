class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller? && controller_name == "sessions"
      "login"
    elsif devise_controller? && controller_name == "registrations"
      "signup"
    else
      "application"
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :active, :department_id, role_ids: [] ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :active, :department_id, role_ids: [] ])
  end
end
