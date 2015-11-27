Rails.application.routes.draw do
  resources :searches

  root to: 'search#index'
end
