Rails.application.routes.draw do
  get '/index', to: 'home#index'
  get '/login', to: 'home#login'
  


  get '/user', to: 'users#new'
  resources :users, only: [:new, :create]
  root 'users#new'
  
  # get 'confirmation/:token', to: 'users#confirmation', as: 'confirmation'
  get '/confirmEmail', to: 'users#confirmEmail'
  post '/confirmEmail', to: 'users#confirmEmail'
  # config/routes.rb
  # post 'process_confirmation', to: 'users#process_confirmation', as: 'process_confirmation'

end
