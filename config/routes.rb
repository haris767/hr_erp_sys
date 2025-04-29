Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}
# root "pages#home"
devise_scope :user do
  get "admin/users", to: "users/registrations#index", as: :admin_user_list
  root to: "users/registrations#admin_dashboard"
  get "profile", to: "users/registrations#show", as: :user_profile
  delete "users/:id", to: "users/registrations#destroy", as: :destroy_user_account

  get  "users/new_user",    to: "users/registrations#new_user",    as: "new_user_by_admin"
  post "users/create_user", to: "users/registrations#create_user", as: "create_user_by_admin"
  get "users/:id/edit", to: "users/registrations#edit", as: "edit_user"
  put "users/:id/update", to: "users/registrations#update", as: "update_user"
  get "admin_dashboard", to: "users/registrations#admin_dashboard", as: :admin_dashboard
  get "employee_dashboard", to: "users/registrations#employee_dashboard", as: :employee_dashboard
end



resources :roles
resources :departments
end
