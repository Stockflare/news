Rails.application.routes.draw do
  get 'recent/(*:date)', to: 'posts#recent', as: :recent

  get 'popular/(*:date)', to: 'posts#popular', as: :popular

  get :ping, to: 'ping#index'

  # You can have the root of your site routed with "root"
  root 'posts#recent'

  # resources :users, except: [:index, :destroy, :edit, :update]

  get :register, to: 'users#register'

  get :login, to: 'users#login'

  post :register, to: 'users#create'

  post :login, to: 'users#authenticate'
end
