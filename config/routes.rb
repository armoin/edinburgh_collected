Rails.application.routes.draw do
  # styleguide
  get 'styleguide' => 'styleguide#blocks'
  get 'styleguide/blocks' => 'styleguide#blocks'
  get 'styleguide/elements' => 'styleguide#elements'

  namespace :my do
    resources :memories
    resources :scrapbooks
    resources :scrapbook_memories

    get '/profile' => 'profile#show'
    get '/profile/edit' => 'profile#edit'
    put '/profile' => 'profile#update'
  end
  resources :memories
  resources :scrapbooks, only: [:index, :show]

  namespace :admin do
    get '/home' => 'home#index'
    get '/moderation' => 'moderation#index'
    put '/approve_memory/:id' => 'moderation#approve', as: 'approve_memory'
    put '/reject_memory/:id' => 'moderation#reject', as: 'reject_memory'
  end

  resources :users, only: [:new, :create] do
    member do
      get :activate
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/signin' => 'sessions#new'
  delete '/signout' => 'sessions#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'memories#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
