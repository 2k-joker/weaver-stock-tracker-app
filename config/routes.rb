Rails.application.routes.draw do
  devise_for :users
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_profile', to: 'users#my_profile'
  get 'my_friends', to: 'users#my_friends'
  get 'search_friend', to: 'users#search'
  get 'search_stock', to: 'stocks#search'
  put 'refresh_stock', to: 'stocks#refresh'
  get 'market_stats', to: 'stocks#stats'
end
