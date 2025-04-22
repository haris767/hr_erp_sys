Rails.application.routes.draw do
  devise_for :users
  root "hr/users#index"

  namespace :hr do
    resources :users, only: [ :index ]  # Adds the route for the users index page
  end
end
