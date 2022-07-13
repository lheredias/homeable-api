Rails.application.routes.draw do
  post    '/login'    => 'sessions#create'
  delete  '/logout'   => 'sessions#destroy'
  post    '/signup'   => 'users#create'

  resource :profile, except: %i[index create], controller: :users

  resources :properties, only: %i[index show create]

  resources :saveds, only: %i[index create]

  resources :users do
    resources :properties, only: %i[create]
    # /games/:id/add_genre
    get "properties", on: :member
  end
end
