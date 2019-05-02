Rails.application.routes.draw do
  root to: 'homes#index'

  get 'ranking', to: 'homes#ranking'
  get 'member', to: 'homes#member'
  get 'privacy-policy', to: 'homes#privacy_policy'

  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get 'leave', to: 'users#leave'
  resources :users, only: [:show, :edit, :new, :create, :update] do
    resources :existences, only: [:edit, :update]
  end

  namespace :api do
    namespace :v1 do
      get 'users', to: 'users#get'
      post 'existences', to: 'existences#post'
    end
  end
end
