PlanSource::Application.routes.draw do
  get "account/select"

  get "about/index"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users

  namespace :api do
    resources :jobs, except: ["new", "edit"]
    resources :plans, except: ["new", "edit", "index"]
    get '/plans/embedded/:id' => 'plans#show_embedded'
    #resources :users, except: ["new", "edit"]
    match "/autocomplete" => "users#autocomplete"
    #resources :shares, only: ["create", "update", "destroy", "show"]
    resources :shares, only: ["create", "destroy", "update"]
    resource :upload, only: ["create"]
    resource :token, only: ["create"] #only retrieve token
    resources :print_sets, only: ["update"]
    match "/download/:id" => "downloads#download"
    match "/page_sizes" => "page_size#page_sizes"
    post "/charge" => "charges#create"
  end

  match "/user/account" => "account#select"
	match "/mobile" => "mobile#index"
	match "/prints" => "prints#index"
  match "/faq" => "faq#index"
  match "/about_us" => "about#index"
  get "/print/:job_id" => "prints#purchase"
  match "/app" => "app#index"

end
