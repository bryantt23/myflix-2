Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/login',   to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invite_token', as: 'register_with_token'
  get '/people', to: 'follows#index'
  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'
  resources :invites, only: [:new, :create]

  resources :follows, only: [:create, :destroy]
  resources :queue_items, only: [:show, :create, :destroy]
  resources :users, only: [:create, :show]
  post "update_queue", to: 'queue_items#update_queue'

  resources :videos do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :user_reviews, only: [:create]
  end

  resources :categories, only: [:show]
end
