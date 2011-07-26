ActionController::Routing::Routes.draw do |map|
  # data entry routes
  map.resources :entries
  map.namespace :entry do |entry|
    entry.resources :testables, :active_scaffold => true
    entry.connect 'testables/new/:tid', :controller => 'testables', :action => 'new'
    entry.connect 'testables/auto_complete_for_patient_rn/:foo', :controller => 'testables', :action => 'auto_complete_for_patient_rn'
    entry.connect 'testables/similar/:rn.:format', :controller => 'testables', :action => 'similar'
    entry.resources :patients, :active_scaffold => true
  end


  # admin routes
  map.resources :manages
  map.namespace :manage do |manage|
    manage.resources :patients, :active_scaffold => true
    manage.resources :departments, :active_scaffold => true
    manage.resources :staff, :active_scaffold => true
    manage.resources :templates, :active_scaffold => true
    manage.resources :fields, :active_scaffold => true, :active_scaffold_sortable => true
    manage.resources :groups, :active_scaffold => true, :active_scaffold_sortable => true
    manage.resources :limits, :active_scaffold => true, :active_scaffold_sortable => true
    manage.resources :links, :active_scaffold => true
    manage.connect '/data/export/:days', :controller => 'data', :action => 'export'
  end

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
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
