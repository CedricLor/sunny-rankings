Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  scope '(:locale)', locale: /fr|en/ do
    get 'static_pages/about'
    get 'static_pages/help'
    get 'static_pages/home'

    get 'reconcile', to: "users#reconcile"

    devise_for :users

    # Do not remove the following route.
    # It is used from the confirm review view to search
    # if the email provided by the user is indeed a user mail
    # resources :users, only: [ :show]

    resources :firms, only: [ :index, :show ] do
      resources :reviews, only: [ :create]
    end
    # resources :firms, only: [ :edit] do
    #   member do
    #     get 'add_review', to: "firms#add_review"
    #   end
    # end

    resources :reviews, only: [ :new, :create, :show ] do
      resources :users, only: [ :edit, :update ]
    end
    resources :reviews, only: [ :new, :create ] do
      member do
        get 'confirm', to: "reviews#confirm"
      end
    end

    get 'pendingreviews', to: "reviews#pendingreviews"

    root 'firms#index'
  end


  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
