Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/login',   to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'

  resources :user_reviews, only: [:create]

  resources :users, only: [:create]

  resources :videos do
    collection do
      get '/search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]

end
