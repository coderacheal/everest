Rails.application.routes.draw do
  # resources :categories
  get 'home/index' 
  # resources :home
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users
  
  resources :categories do
    resources :expenses
  end
  root "home#index"
end
