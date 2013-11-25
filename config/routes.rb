Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  namespace :admin do
    resources :videos, only: [:create, :new, :edit, :update]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine => '/stripe_events'

  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get '/logout',   to: 'sessions#destroy'

  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invite_token',
                          as: 'register_with_token'

  get '/people', to: 'follows#index'

  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]

  get 'expired_token', to: 'password_resets#expired_token'

  resources :invites, only: [:new, :create]

  resources :follows, only: [:create, :destroy]

  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  resources :users, only: [:create, :show, :edit, :update] do
    member do
      get '/plan_and_billing', to: 'users#plan_and_billing'
      post '/cancel_service', to: 'users#cancel_service'
    end
  end

  resources :videos, only: [:index, :show] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :user_reviews, only: [:create]
  end

  resources :categories, only: [:show]
end
