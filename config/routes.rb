PlanSource::Application.routes.draw do
  get "signup_links/edit"

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users

  resources :jobs do
    resources :share_links, only: [:new, :create]
  end

  get '/sl/:token' => 'share_links#login', as: :login_share_link
  resources :share_links, only: [:edit, :update, :destroy]
  get '/share_links/:id/should_delete' => 'share_links#should_delete', as: :should_delete_share_link

  get '/jobs/:id/shares' => 'jobs#shares', as: :job_shares
  get '/jobs/:id/should_delete' => 'jobs#should_delete', as: :should_delete_job
  get '/jobs/:id/:tab' => 'jobs#show', as: :job_tab

  scope '/jobs/:job_id/:tab', as: :job_tab do
    resources :plans, only: [:new, :create]
  end

  resources :plans, only: [:show, :edit, :update, :destroy]
  get '/plans/:id/should_delete' => 'plans#should_delete', as: :should_delete_plan

  get '/document/:id' => 'document#show', as: :document
  get '/document/:id/download' => 'document#download', as: :download_document
  post '/document/upload' => 'document#upload', as: :upload_document



  namespace :api do
    resources :jobs, except: ["new", "edit"], :as => :job
    post '/jobs/share_link' => 'jobs#sub_share_link'
    post '/jobs/:id/project_manager' => 'jobs#project_manager'

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

    post '/rfis' => 'rfis#create'
    put '/rfis/:id' => 'rfis#update'
    delete '/rfis/:id' => 'rfis#destroy'
    post '/rfis/:id/assign' => 'rfis#assign'
    get '/rfis/download_attachment/:id' => 'rfis#download_attachment'

    post '/asis' => 'asis#create'
    put '/asis/:id' => 'asis#update'
    post '/asis/:id/assign' => 'asis#assign'
    get '/asis/download_attachment/:id' => 'asis#download_attachment'

    post '/photos/upload' => 'photos#upload_photos'
    post '/photos/submit' => 'photos#submit_photos'
    get '/photos/download/:id' => 'photos#download_photo'
    post '/photos/:id/destroy' => 'photos#destroy'
    get '/jobs/:job_id/photos' => 'photos#show'
    post '/photos/:id' => 'photos#update'

    # Use submittals#upload_attachments for right now
    # TODO move upload_attachments into a generic upload endpoint
    post '/troubleshoot/upload_attachments' => 'submittals#upload_attachments'
    post '/troubleshoot' => 'troubleshoot#create'
  end

  get '/view' => 'pdf#index', as: "view_pdf"
  get '/photos/:id/gallery' => 'api/photos#gallery'

  get '/notifications/unsubscribe/:id' => 'notification#unsubscribe', as: :unsubscribe

  get '/jobs/:id/share' => 'api/jobs#show_sub_share_link'
  get '/share_link/company_name' => 'api/jobs#share_link_company_name'
  post '/share_link/company_name' => 'api/jobs#set_share_link_company_name', as: "set_share_link_company_name"

  resources :users, only: ["index", "edit", "update", "destroy"]
  get "/users/:id/demote" => "users#demote", as: "demote"
  get "/users/signup_link/:key", to: "signup_links#edit", as: "signup_link"
  put "/users/signup_link/:key", to: "signup_links#update"

  post "/reports/shop_drawings" => "reports#shop_drawings"
  get "/reports/shop_drawings/jobs" => "reports#shop_drawing_jobs"

  get "/admin/sub_logins" => "admin#sub_logins"
  delete "/admin/sub_logins/:id" => "admin#delete_sub_login", as: "delete_sub_login"

  match "/mobile" => "mobile#index"
end
