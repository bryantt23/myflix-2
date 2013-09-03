Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'
  get '/', to: 'videos#index'
  get '/home', to: 'videos#index'


  resources :videos
  resources :categories, only: [:show]

end
