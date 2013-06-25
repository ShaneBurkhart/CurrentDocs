PlanSource::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, only: ["index", "show"]

  namespace :api do
    resources :jobs, except: ["new", "edit"]
    resources :plans, except: ["new", "edit"]
    resources :users, except: ["new", "edit"]
    resource :upload, only: ["create"]
    match "/download/:id" => "downloads#download"
  end

	match "/mobile" => "mobile#index"
	match "/prints" => "prints#index"
  match "/app" => "app#index"

end