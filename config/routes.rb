Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

devise_scope :user do
  root to: "users/registrations#index"
  get "admin/users", to: "users/registrations#index", as: :admin_user_list

  get "profile", to: "users/registrations#show", as: :user_profile
  delete "users", to: "users/registrations#destroy", as: :destroy_user_account
end
devise_scope :user do
  get  "users/new_user",    to: "users/registrations#new_user",    as: "new_user_by_admin"
  post "users/create_user", to: "users/registrations#create_user", as: "create_user_by_admin"
end
end
