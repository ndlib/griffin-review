Griffin::Application.routes.draw do

  devise_for :users


  ############################
  # Administrative Functions #
  ############################
  namespace :admin do
    resources :role
    resources :user
    resources :open_video
    resources :group
    resources :open_item
    resources :item
    resources :video
  end
  match '/img/glyphicons-halflings.png' => redirect('/assets/img/glyphicons-halflings.png')
  match '/img/glyphicons-halflings-white.png' => redirect('/assets/img/glyphicons-halflings-white.png')
  scope '/admin/video/request', :controller => 'admin/video_workflow' do
    get 'requests_by_semester', :as => nil, :path => '/by_semester/:s_id'
    post 'state', :action => 'requests_by_state', :as => 'requests_by_state'
    post 'transition', :action => 'request_transition', :as => 'request_transition'
    get 'all', :action => 'full_list', :as => 'video_request_all'
  end
  scope '/admin/item', :controller => 'admin/item' do
    get 'all', :action => 'full_list', :as => 'admin_item_all'
  end
  scope '/admin/video', :controller => 'admin/video_workflow' do
    get 'new', :as => 'request_admin_new', :path => '/request/new'
    resource :request, :controller => 'admin/video_workflow', :only => :none do
      post 'create', :as => nil, :path => ''
    end
    resources :request, :controller => 'admin/video_workflow', :only => :none do
      put 'update', :as => nil, :path => ''
      get 'edit', :as => 'admin_edit'
      delete 'destroy', :as => 'admin_destroy'
      get 'show', :as => 'admin_show', :path => ''
    end
  end
  scope '/admin', :controller => 'admin/video' do
    post 'find_record', :as => nil, :path => '/find-record'
    delete 'destroy_attribute', :as => 'attribute_admin_destroy'
  end
  scope '/admin', :controller => 'admin/video_workflow' do
    resources :video_workflow, :controller => 'admin/video_workflow' do
      get 'autocomplete_video_name', :on => :collection
      get 'autocomplete_user_username', :on => :collection
    end
    post 'requester', :as => 'requester', :path => '/requester/:user_id'
    post 'request_record', :as => 'request', :path => '/request/:request_id'
    post 'tech_data', :as => 'tech_data', :path => '/tech_data'
    post 'request_tech', :as => 'request_tech', :path => '/request_tech/:request_id'
    post 'destroy_technical_metadata', :as => 'destroy_technical_metadata', :path => '/destroy_tech_metadata'
  end
  scope '/admin', :controller => 'admin' do
    get 'index', :as => 'admin_index', :path => ''
    get 'not_authorized', :as => 'admin_not_authorized', :path => '/not-authorized'
    post 'user_info', :as => 'user_info', :path => '/user/:user_id'
    resource :metadata_attribute, :controller => 'admin', :only => :none do
      collection do
        get 'all_metadata_attributes', :as => 'all', :path => '/all'
        get 'new', :action => 'new_metadata_attribute', :as => 'new', :path => '/new'
        post 'create', :action => 'create_metadata_attribute', :as => nil, :path => '/create'
      end
    end
    resources :metadata_attribute, :controller => 'admin', :only => :none do
        get 'edit', :action => 'edit_metadata_attribute'
        put 'update', :action => 'update_metadata_attribute', :as => nil
        delete 'destroy', :action => 'destroy_metadata_attribute'
    end
  end

  ###########################
  # External User Functions #
  ###########################
  scope '/', :controller => 'external' do
    get 'not_authorized', :as => 'external_not_authorized', :path => 'not-authorized'
  end
  scope '/video/request', :controller => 'external/request' do
    get 'new', :as => 'new_video_request'
    get 'video_request_multi_status', :as => 'video_request_multi_status', :path => '/multiple/status'
    get 'video_request_status', :as => 'video_request_status', :path => '/:r_id/status'
    post 'create', :path => 'copy', :as => 'video_request'
  end


  root :to => 'user_course_listings#index'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  match "login", :controller => 'development_login', :action => 'login'

  resources :courses, controller: 'user_course_listings', only: [ 'index', 'show', 'create' ] do
    resources :get_reserves, as: 'get_reserve', only: [ 'show' ]
    resources :reserves, controller: 'instructor_new_reserves', only: [ 'new', 'create' ]
    # resources :copy_reserves, :path => 'copy', only: [ 'create' ]
    resources :reserves, controller: 'course_reserves'
    match 'copy' => 'copy_reserves#copy_step1', as: :copy_step1
    match 'copy/:from_course_id' => 'copy_reserves#copy_step2', as: :copy_step2
    match 'copy/:from_course_id/copy' => 'copy_reserves#copy', :via => :post, as: :copy


    get 'copy_old_reserves', to: 'admin/copy_old_reserves#new'
    post 'copy_old_reserves', to: 'admin/copy_old_reserves#create'

    resources :topics, as: 'reserve_topic', path: 'update_topics', only: [ 'update' ]
  end


  resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]


  scope '/admin' do
    resources :requests, controller: 'admin/requests'
    resources :meta_datas, controller: 'admin/requests_meta_data'
    resources :fair_use, controller: 'admin/requests_fair_use'
    resources :resources, controller: 'admin/requests_resources'
    resources :admin_courses, controller: 'admin/courses'
    resources :semesters, controller: 'admin/semesters'

  end


end
