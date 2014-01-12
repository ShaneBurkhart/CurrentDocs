PlanSource::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users

  mount StripeEvent::Engine => '/_stripe'

  namespace :api do
    resources :jobs, except: ["new", "edit"]
    resources :plans, except: ["new", "edit", "index"]
    get '/plans/embedded/:id' => 'plans#show_embedded'
    get '/user/contacts' => 'users#contacts'
    post '/user/contacts' => 'users#add_contacts'
    resources :shares, only: ["create", "destroy", "update"]
    post "/shares/batch" => "shares#batch"
    resource :upload, only: ["create"]
    resource :token, only: ["create"] #only retrieve token
    resources :print_sets, only: ["update"]
    match "/download/:id" => "downloads#download"
    match "/page_sizes" => "page_size#page_sizes"
    post "/charge" => "charges#create"
  end

  get "/users" => "users#index"
  get "/users/:id/demote" => "users#demote", as: "demote"

  resource :subscription, only: ["show", "update"]
  match "/mobile" => "mobile#index"
  match "/prints" => "prints#index"
  match "/faq" => "faq#index"
  match "/about_us" => "about#index"
  match "/app" => "app#index"

end
