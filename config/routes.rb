Rails.application.routes.draw do
  post    '/login'    => 'sessions#create'
  delete  '/logout'   => 'sessions#destroy'
  post    '/signup'   => 'users#create'
  get    '/addresses'   => 'properties#list_addresses'

  resource :profile, except: %i[index create], controller: :users

  resources :properties, only: %i[index show create update destroy]

  resources :saveds, only: %i[index create update destroy]
  
  resources :users do
    # resources :properties, only: %i[get]
    # /games/:id/add_genre
    get "listed_properties", on: :member
  end
end
