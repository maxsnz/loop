Loop::Application.routes.draw do
  resources :pages
  root "pages#index"
  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#failure'

  namespace :api, defaults: { format: :json } do
    resources :results, only: [:index, :create, :update] do
      member do
        post :publish
      end
      collection do
        get :all
      end
    end
    resources :players, only: [:index, :create, :update] do
      member do
        get :show
      end
      collection do
        get :all
      end
    end
  end

  ActiveAdmin.routes(self)
end
