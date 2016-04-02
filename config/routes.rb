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
  get 'forgot_password', to: "passwords#new"
  post 'forgot_password', to: "passwords#create"
  get 'password_reset/:reset_token', to: "passwords#show"
  post 'password_reset', to: "passwords#update"
  resources :queue_items, only: [:create, :destroy]
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'comment', on: :member
  end
  resources :relationships, only: [:destroy, :create]
end
