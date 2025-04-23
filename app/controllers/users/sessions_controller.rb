# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout :select_layout

  private

  def select_layout
    if action_name == "new"
      "login" #  for login
    else
      "application" # ✅ Use layout elsewhere (if needed)
    end
  end
end
