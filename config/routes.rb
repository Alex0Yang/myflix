Myflix::Application.routes.draw do
  root "videos#index"
  get 'ui(/:action)', controller: 'ui'
  get '/genre/:id', to: 'categories#show', as: 'category'
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
  end
end
