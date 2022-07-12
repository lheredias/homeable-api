Rails.application.routes.draw do
  post    '/login'    => 'sessions#create'
  delete  '/logout'   => 'sessions#destroy'
  post    '/signup'   => 'users#create'

  resource :profile, except: %i[index create], controller: :users
end
