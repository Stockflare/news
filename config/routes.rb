Rails.application.routes.draw do
  get 'recent/(*:date)', to: 'posts#recent'

  get 'popular/(*:date)', to: 'posts#popular'

  # You can have the root of your site routed with "root"
  root 'posts#recent'

  # resources :users, except: [:index, :destroy, :edit, :update]

  # get :register, to: 'users#register'
  #
  # post :register, to: 'users#create'
  #
  # get :login, to: 'users#login'
  #
  # post :login, to: 'users#get'
end
