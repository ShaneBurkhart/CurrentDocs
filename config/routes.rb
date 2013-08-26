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
    resource :token, only: ["create"] #only retrieve token
    match "/download/:id" => "downloads#download"
    match "/page_sizes" => "page_size#page_sizes"
    post "/charge" => "charges#create"
  end

	match "/mobile" => "mobile#index"
	match "/prints" => "prints#index"
  get "/print/:job_id" => "prints#purchase"
  match "/app" => "app#index"

end
