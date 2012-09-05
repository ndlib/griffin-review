Griffin::Application.routes.draw do

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # Testing multi model access
  # match "/group/list", :controller => 'group', :action => 'list'
  # match "/groups", :method => 'get', :controller => 'group', :action => 'list'


  # admin
  namespace :admin do
    resources :role
    resources :user
    resources :video
    resources :group
    resources :item
  end

  post "/admin/find-record", :controller => 'admin/video', :action => 'find_record'
  get "/admin/not-authorized", :controller => 'admin', :action => 'not_authorized', :as => 'admin_not_authorized'
  get "/admin", :controller => 'admin', :action => 'index', :as => 'admin_index'

  # video workflow
  get "/admin/video/request/all", :controller => 'admin/video_workflow', :action => 'full_list'
  post "/admin/requester/:user_id", :controller => 'admin/video_workflow', :action => 'requester', :as => 'requester'
  post "/admin/request/:request_id", :controller => 'admin/video_workflow', :action => 'request_record', :as => 'request'
  post "/admin/video/request/state", :controller => 'admin/video_workflow', :action => 'requests_by_state', :as => 'requests_by_state'
  post "/admin/video/request/transition", :controller => 'admin/video_workflow', :action => 'request_transition', :as => 'request_transition'
  get "/admin/video/request/:r_id", :controller => 'admin/video_workflow', :action => 'show'
  get "/admin/video/request/by_semester/:s_id", :controller => 'admin/video_workflow', :action => 'requests_by_semester'
  delete "/admin/video/request/:r_id", :controller => 'admin/video_workflow', :action => 'destroy', :as => 'delete_admin_request'
  put "/admin/video/request/:r_id", :controller => 'admin/video_workflow', :action => 'update'
  get "/admin/video/request/:r_id/edit", :controller => 'admin/video_workflow', :action => 'edit', :as => 'edit_admin_request'

  # metadata attributes
  scope '/admin' do
    resources :metadata_attributes, :controller => 'admin' do # , :controller => 'admin', :as => 'metadata'
      get 'metadata_index'
    end
  end

  # users
  post "/admin/user/:user_id", :controller => 'admin', :action => 'user_info', :as => 'user_info'

  # semesters
  get "/admin/semester/all", :controller => 'admin', :action => 'show_all_semesters'
  get "/admin/semester/active", :controller => 'admin', :action => 'show_proximate_semesters'
  get "/admin/semester/new", :controller => 'admin', :action => 'new_semester', :as => 'new_admin_semester'
  post "/admin/semester", :controller => 'admin', :action => 'create_semester'
  get "/admin/semester", :controller => 'admin', :action => 'index_semester'
  get "/admin/semester/:s_id/edit", :controller => 'admin', :action => 'edit_semester', :as => 'edit_admin_semester'
  put "/admin/semester/:s_id", :controller => 'admin', :action => 'update_semester'
  get "/admin/semester/:s_id", :controller => 'admin', :action => 'show_semester', :as => 'admin_semester'

  # external
  root :to => 'external#index'
  get "/not-authorized", :controller => 'external', :action => 'not_authorized', :as => 'external_not_authorized'

  get "/video/request/new", :controller => 'external/request', :action => 'new', :as => 'new_video_request'
  post "/video/request", :controller => 'external/request', :action => 'create'
  delete "/video/request/:r_id", :controller => 'admin/video_queue', :action => 'destroy'
  get "/video/request/:r_id/status", :controller => 'external/request', :action => 'video_request_status', :as => 'video_request_status'

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
