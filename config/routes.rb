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


# Rails.application.routes.draw do
  # resources :categories
#   get 'expenses/index'
#   get 'categories/index'
#   get 'home/index'



#   get '/home', to: 'home#index'
  

  
#   resources :categories do
#     resources :expenses
#   end
#   devise_for :users
  

#   root 'home#index'
# end