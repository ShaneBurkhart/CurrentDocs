PlanSource::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, only: ["index", "show"]

  namespace :api do
    resources :jobs, except: ["new", "edit"] do
      resources :plans, except: ["new", "edit"]
    end
  end

	match "/mobile" => "mobile#index"
	match "/prints" => "prints#index"
  match "/app" => "app#index"

#bad implementation of about pages routes(Shouldn't user resources)
	#resources :prints, only: ["index"]
end