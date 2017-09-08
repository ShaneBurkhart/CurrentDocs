PlanSource::Application.routes.draw do
  get "signup_links/edit"

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users

  namespace :api do
    resources :jobs, except: ["new", "edit"], :as => :job
    post '/jobs/share_link' => 'jobs#sub_share_link'

    resources :plans, except: ["new", "edit", "index"]
    get '/plans/embedded/:id' => 'plans#show_embedded'
    get '/plans/records/:id' => 'plans#plan_records'
    post '/plans/records' => 'plan_records#batch_update'

    get '/user/contacts' => 'users#contacts'
    post '/user/contacts' => 'users#add_contacts'

    resources :shares, only: ["create", "destroy", "update"]
    post "/shares/batch" => "shares#batch"

    resource :upload, only: ["create"]
    resource :token, only: ["create"] #only retrieve token
    match "/download/:id" => "downloads#download"

    post '/message' => 'messages#group'
    post '/message' => 'messages#group'

    get '/submittals/:plan_id' => 'submittals#index'
    post '/submittals' => 'submittals#create'
    post '/submittals/upload_attachments' => 'submittals#upload_attachments'
    get '/submittals/download_attachment/:id' => 'submittals#download_attachment'
    post '/submittals/:id/destroy' => 'submittals#destroy'
    post '/submittals/:id' => 'submittals#update'

    post '/photos/upload' => 'photos#upload_photos'
    post '/photos/submit' => 'photos#submit_photos'
    get '/photos/download/:id' => 'photos#download_photo'
    post '/photos/:id/destroy' => 'photos#destroy'
  end

  get '/view' => 'pdf#index', as: "view_pdf"

  get '/notifications/unsubscribe/:id' => 'notification#unsubscribe', as: :unsubscribe
  get '/app#/jobs/:id' => 'home#index', as: :jobs_link

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
