Loop::Application.routes.draw do
  resources :pages
  root "pages#index"
  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#failure'

  namespace :api, defaults: { format: :json } do
    # resources :photos, only: [:index, :show]
    # resources :likes, only: [:create, :index]
  end

  ActiveAdmin.routes(self)
end
