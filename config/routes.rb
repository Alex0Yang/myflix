Myflix::Application.routes.draw do
  root "sessions#front"
  get 'ui(/:action)', controller: 'ui'
  get '/genre/:id', to: 'categories#show', as: 'category'
  get '/sign_in', to:'sessions#new'
  post '/sign_in', to:'sessions#create'
  post '/sign_out', to:'sessions#destroy'
  get '/register', to:'users#new'
  resources :users, only: [:create, :show]
  get 'my_queue', to:"queue_items#index"
  get 'people', to: "relationships#index"
  post 'update_queue', to:"queue_items#update_queue"

  get 'forgot_password', to: "forgot_passwords#new"
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:create]
  get 'password_resets/:reset_token', to: "password_resets#show",as: :password_reset
  get 'expired_token', to: 'password_resets#expired_token'

  resources :queue_items, only: [:create, :destroy]
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'comment', on: :member
  end
  resources :relationships, only: [:destroy, :create]
end
