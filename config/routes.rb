Rails.application.routes.draw do
  get "departments/index"
  get "departments/show"
  get "departments/new"
  get "departments/edit"
  get "departments/create"
  get "departments/update"
  get "departments/destroy"
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}
root "pages#home"
devise_scope :user do
  get "admin/users", to: "users/registrations#index", as: :admin_user_list

  get "profile", to: "users/registrations#show", as: :user_profile
  delete "users/:id", to: "users/registrations#destroy", as: :destroy_user_account
end
devise_scope :user do
  get  "users/new_user",    to: "users/registrations#new_user",    as: "new_user_by_admin"
  post "users/create_user", to: "users/registrations#create_user", as: "create_user_by_admin"
  get "users/:id/edit", to: "users/registrations#edit", as: "edit_user"
  put "users/:id/update", to: "users/registrations#update", as: "update_user"
end



resources :roles
resources :departments
end
