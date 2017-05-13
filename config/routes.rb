Rails.application.routes.draw do
  resources :pics
  get 'home/index'

  get 'welcome/home'
  get "home", to: "home#index", as: "user_root"
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [ :show, :edit, :update ]
  resources :posts, only: [ :create, :destroy, :new ]
  get "posts/get_geo"
  get "posts/:id", to: 'posts#show'
end
