Rails.application.routes.draw do
  root to: 'users#index'

  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get 'ranking', to: 'users#ranking'
  get 'member', to: 'users#member'
  get 'leave', to: 'users#leave'

  resources :users do
    resources :existences, only: [:edit, :update]
  end

  namespace :api do
    namespace :v1 do
      get 'users', to: 'users#get'
      post 'existences', to: 'existences#post'
    end
  end
end
