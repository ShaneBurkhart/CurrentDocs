PlanSource::Application.routes.draw do
  get "team/view"

  get "team/edit"

  root :to => "home#index"
  devise_for :users

  # TODO Let Devise handle registration with the :registerable module
  # when we let users create their own account.
  get '/user/registration/edit' => 'registration#edit', as: :edit_user_registration
  put '/user/registration' => 'registration#update', as: :user_registration

  resources :jobs do
    resources :share_links, only: [:new, :create]
  end

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

  resources :share_links
  get '/share_links/:id/should_delete' => 'share_links#should_delete', as: :should_delete_share_link
  get '/sl/:token' => 'share_links#login', as: :login_share_link

  resources :job_permissions, only: [:edit, :update, :destroy]
  get '/job_permissions/:id/should_delete' => 'job_permissions#should_delete', as: :should_delete_job_permission
end
