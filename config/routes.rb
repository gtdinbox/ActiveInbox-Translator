ActiveInboxTranslator::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.


  match 'messages/:lang' => 'messages#create', :via => 'post', :as => 'messages'
  match 'messages/:lang/:id' => 'messages#update', :via => 'put', :as => 'messages'
  match 'messages(/:lang)' => 'messages#show', :via => 'get', :as => 'messages'

  match 'pages/:lang/:id/edit' => 'page#edit', :via => 'get', :as => 'page_form'
  match 'pages/:lang/:id' => 'page#update', :via => 'put', :as => 'page_update'
  match 'pages(/:lang)' => 'page#index', :via => 'get', :as => 'pages'

  get "login" => "user_session#new", :as => 'login'
  post "login" => "user_session#create", :as => 'login'
  delete "logout" => "user_session#destroy", :as => 'logout'

  get "signup" => "user#new", :as => 'signup'
  post "signup" => "user#create", :as => 'signup'
  match "user/:id/edit" => "user#edit", :via => 'get', :as => 'edit_account'
  match "user/:id" => "user#destroy", :via => 'delete', :as => 'user_delete'
  match "user/:id" => "user#update", :via => 'put', :as => 'user'
  match "user" => "user#index", :via => 'get', :as => 'user_index'

  get "export" => "application#export_bundle"

  root :to => 'messages#show', :via => 'get', :lang => 'it'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
