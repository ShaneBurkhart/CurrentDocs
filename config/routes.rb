PlanSource::Application.routes.draw do
  get "signup_links/edit"

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users

  namespace :api do
    resources :jobs, except: ["new", "edit"]
    post '/jobs/share_link' => 'jobs#sub_share_link'
    resources :plans, except: ["new", "edit", "index"]
    get '/plans/embedded/:id' => 'plans#show_embedded'
    get '/user/contacts' => 'users#contacts'
    post '/user/contacts' => 'users#add_contacts'
    resources :shares, only: ["create", "destroy", "update"]
    post "/shares/batch" => "shares#batch"
    resource :upload, only: ["create"]
    resource :token, only: ["create"] #only retrieve token
    match "/download/:id" => "downloads#download"
    post '/message' => 'messages#group'
  end

  get '/jobs/:id/share' => 'api/jobs#show_sub_share_link'

  resources :users, only: ["index", "edit", "update", "destroy"]
  get "/users/:id/demote" => "users#demote", as: "demote"
  get "/users/signup_link/:key", to: "signup_links#edit", as: "signup_link"
  put "/users/signup_link/:key", to: "signup_links#update"

  match "/mobile" => "mobile#index"
  match "/app" => "app#index"
  match "/ve_pictures" => "ve_pictures#index"
  match "/ve_pictures/all" => "ve_pictures#images"
  post "/ve_pictures/delete" => "ve_pictures#destroy"
end
