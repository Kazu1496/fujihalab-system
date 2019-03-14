Rails.application.routes.draw do
  root to: 'users#index'

  resources :users, only: [:index, :show, :edit, :update] do
    resources :existences, only: [:edit, :update]
  end

  namespace :api do
    namespace :v1 do
      post 'existences', to: 'existences#post'
    end
  end
end
