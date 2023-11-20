Rails.application.routes.draw do
  get '/index', to: 'home#index'
  get '/login', to: 'login#login'
  post '/login', to: 'login#verifyOTP'

  get '/loginConfirm', to: 'login#loginConfirm'
  post '/loginConfirm', to: 'login#loginConfirm'

  get '/user_detail', to: 'login#user_detail'
  post '/user_detail', to: 'login#user_detail'
  
  get '/user', to: 'users#new'
  resources :users, only: [:new, :create]
  root 'users#new'
  
  # get 'confirmation/:token', to: 'users#confirmation', as: 'confirmation'
  get '/confirmEmail', to: 'users#confirmEmail'
  post '/confirmEmail', to: 'users#confirmEmail'
  # config/routes.rb
  # post 'process_confirmation', to: 'users#process_confirmation', as: 'process_confirmation'

end
