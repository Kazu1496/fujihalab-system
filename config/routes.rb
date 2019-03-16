Rails.application.routes.draw do
  root to: 'users#index'

  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get 'ranking', to: 'users#ranking'

  resources :users, only: [:index, :show, :edit, :update] do
    resources :existences, only: [:edit, :update]
  end

  namespace :api do
    namespace :v1 do
      post 'existences', to: 'existences#post'
    end
  end
end
