ActionController::Routing::Routes.draw do |map|
  map.resources :invite_requests
  map.connect '/thanks', :controller => "site", :action => "thanks"

  map.resources :invites

  map.root :controller => "site", :action => "home"

  #map.resources :apps, :member => [:fork, :deploy] do |app|
  #  app.resources :files, :requirements => { :id => /.*/ }
  #  app.resources :commits, :only => [:show, :create, :index]
  #end
  map.resource :user_session
  map.join '/join', :controller => "users", :action => "new",  :conditions => { :method => :get }
  map.connect '/join', :controller => "users", :action => "create",  :conditions => { :method => :post }
  map.connect '/signin', :controller => "user_sessions", :action => "new"
  map.connect '/signout', :controller => "user_sessions", :action => "destroy"
  #map.resources :users

  #map.apps '/apps', :controller => "apps", :action => "create", :conditions => { :method => :post }
  map.resources :apps, :member => [:name]
  map.connect ':login', :controller => "users", :action => "show"
  map.connect ':owner_id/:name.:format', :controller => "apps", :action => "show"

  map.connect ':owner_id/:name/fork', :controller => "apps", :action => "fork"
  map.connect ':owner_id/:name/loading', :controller => "apps", :action => "loading"
  map.connect ':owner_id/:name/deploy', :controller => "apps", :action => "deploy"

  map.connect ':owner_id/:name/commits', :controller => "commits", :action => "index", :conditions => { :method => :get }
  map.connect ':owner_id/:name/commits', :controller => "commits", :action => "create", :conditions => { :method => :post }
  map.connect ':owner_id/:name/commits/:index', :controller => "commits", :action => "show"
  map.connect ':owner_id/:name/files/:filename', :controller => "files", :action => "update", :conditions => { :method => :put }, :requirements => { :filename => /.*/ }
  #map.user ':id', :controller => "users", :action => "show"
  #map.app ':owner_id/:id', :controller => "apps", :action => "show"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
