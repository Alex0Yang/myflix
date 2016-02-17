Myflix::Application.routes.draw do
  root "sessions#front"
  get 'ui(/:action)', controller: 'ui'
  get '/genre/:id', to: 'categories#show', as: 'category'
  get '/sign_in', to:'sessions#new'
  post '/sign_in', to:'sessions#create'
  post '/sign_out', to:'sessions#destroy'
  get '/register', to:'users#new'
  resources :users, only: [:create]
  get 'my_queue', to:"queue_items#index"
  resources :queue_items, only: [:create, :destroy]
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'comment', on: :member
  end
end
