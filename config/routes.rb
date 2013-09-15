Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/login',   to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'

  resources :my_queues, only: [:show, :create, :update]
  resources :users, only: [:create]

  resources :videos do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :user_reviews, only: [:create]
  end

  resources :categories, only: [:show]
end
