Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  get '/',        to: 'sessions#index'
  get '/home',    to: 'sessions#index'
  get '/login',   to: 'sessions#new'
  post '/login',  to: 'sessions#create'

  resources :users

  resources :videos do
    collection do
      get '/search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]

end
