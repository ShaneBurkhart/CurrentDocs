PlanSource::Application.routes.draw do
  get "signup_links/edit"

    authenticated :user do
	root :to => 'home#index'
    end
    root :to => "home#index"
    devise_for :users

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
	match "/download/:id" => "downloads#download"
	post '/message' => 'messages#group'
    end

    resources :users, only: ["index", "edit", "update", "destroy"]
    get "/users/:id/demote" => "users#demote", as: "demote"
    get "/users/signup_link/:key", to: "signup_links#edit", as: "signup_link"
    put "/users/signup_link/:key", to: "signup_links#update"

    match "/mobile" => "mobile#index"
    match "/app" => "app#index"

end
