RtRails32::Application.routes.draw do
  resources :users do
    collection do
      get :login
      post :login
      get :logout
    end
  end

  resources :released_animal do
    collection do
      post :ajakohastama
    end
  end

  resources :track do
    member do
      get :animal
    end
    collection do
      post :ajakohastama
    end
  end

  resources :ajax do
    member do
      get :ra
      get :rt
      get :ra_rt
    end
    collection do
      post :ra
    end
  end

  resources :triangulate do
    collection do
      post :map
    end
  end

  resources :mapping do
    collection do
      post :basic_path
      get :enable_marker
      get :disable_marker
    end
  end

  resources :reports do
    member do
      get :animal
      get :general_report
      get :radiotracking
    end
    collection do
      get :animals
    end
  end

  match "/login" => "users#login"
  match "/logout" => "users#logout"
  root :to => "users#login"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
