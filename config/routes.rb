Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :posts, only: [:create, :top] do
        get :top, on: :collection

        resources :rates, only: [:create]
      end

      resources :users, only: [:ip_groups] do
        get :ip_groups, on: :collection
      end
    end
  end
end
