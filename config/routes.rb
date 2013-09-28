Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/login',   to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/people', to: 'follows#index'

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
