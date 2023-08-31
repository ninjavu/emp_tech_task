Rails.application.routes.draw do
  resources :authenticate, only: :create
  resources :transactions, only: [:index, :create]
  resources :merchants, only: [:index, :update, :destroy]
end
