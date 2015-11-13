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
  get '/share_link/company_name' => 'api/jobs#share_link_company_name'
  post '/share_link/company_name' => 'api/jobs#set_share_link_company_name', as: "set_share_link_company_name"

  resources :users, only: ["index", "edit", "update", "destroy"]
  get "/users/:id/demote" => "users#demote", as: "demote"
  get "/users/signup_link/:key", to: "signup_links#edit", as: "signup_link"
  put "/users/signup_link/:key", to: "signup_links#update"

  get "/admin/sub_logins" => "admin#sub_logins"
  delete "/admin/sub_logins/:id" => "admin#delete_sub_login", as: "delete_sub_login"

  match "/mobile" => "mobile#index"
  match "/app" => "app#index"
  match "/ve_pictures" => "ve_pictures#index"
  match "/ve_pictures/all" => "ve_pictures#images"
  post "/ve_pictures/delete" => "ve_pictures#destroy"
end
