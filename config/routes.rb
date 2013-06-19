PlanSource::Application.routes.draw do
  authenticated :user do
    root :to => 'user#show'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  resources :magazines do
	  resources :ads
	end
end