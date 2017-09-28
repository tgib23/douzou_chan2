Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  scope "(:locale)" do
    resources :pics
    get 'home/index'
    get 'home/signin'
    get 'home/admin'

    get "home", to: "home#index", as: "user_root"
    root 'home#index'

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :users, only: [ :show, :edit, :update ]
    resources :posts, only: [ :create, :destroy, :new, :edit ]
    get "posts/get_geo"
    get "posts/:id", to: 'posts#show'
    patch 'posts/:id', controller: 'posts', action: :update
    resources :contributions, only: [ :index, :show, :edit, :new, :update ]
    resources :comments,          only: [:create, :destroy]
  end
end
