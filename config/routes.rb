PlanSource::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users

  namespace :api do
    resources :jobs, except: ["new", "edit"]
    resources :plans, except: ["new", "edit", "index"]
    #resources :users, except: ["new", "edit"]
    match "/autocomplete" => "users#autocomplete"
    #resources :shares, only: ["create", "update", "destroy", "show"]
    resources :shares, only: ["create", "destroy"]
    resource :upload, only: ["create"]
    match "/download/:id" => "downloads#download"
  end

	match "/mobile" => "mobile#index"
	match "/prints" => "prints#index"
  match "/app" => "app#index"

end