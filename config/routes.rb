Griffin::Application.routes.draw do

  devise_for :users

  ############################
  # Administrative Functions # 
  ############################
  namespace :admin do
    resources :role
    resources :user
    resources :video
    resources :group
    resources :item
  end
  scope '/admin/video/request', :controller => 'admin/video_workflow' do
    get 'requests_by_semester', :as => nil, :path => '/by_semester/:s_id'
    post 'state', :action => 'requests_by_state', :as => 'requests_by_state'
    post 'transition', :action => 'request_transition', :as => 'request_transition'
    get 'all', :action => 'full_list', :as => 'video_request_all'
  end
  scope '/admin/video', :controller => 'admin/video_workflow' do
    resources :request, :controller => 'admin/video_workflow', :only => :none do
      put 'update', :as => nil, :path => ''
      get 'edit', :as => 'admin_edit'
      delete 'destroy', :as => 'admin_destroy'
      get 'show', :as => nil, :path => ''
    end
  end
  scope '/admin', :controller => 'admin/video' do
    post 'find_record', :as => nil, :path => '/find-record'
  end
  scope '/admin', :controller => 'admin/video_workflow' do
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
    resource :semester, :controller => 'admin', :only => :none do
      collection do
        get 'all', :action => 'show_all_semesters'
        get 'new', :action => 'new_semester', :as => 'new', :path => '/new'
        post 'create', :action => 'create_semester', :as => nil, :path => '/create'
        get 'active', :action => 'show_proximate_semesters'
      end
    end
    resources :semester, :controller => 'admin', :only => :none do
      get 'edit', :action => 'edit_semester', :as => 'edit'
      put 'update', :action => 'update_semester', :as => nil
      get 'show', :action => 'show_semester', :as => '', :path => ''
    end
  end

  ###########################
  # External User Functions #
  ###########################
  root :to => 'external#index'
  scope '/', :controller => 'external' do
    get 'not_authorized', :as => 'external_not_authorized', :path => 'not-authorized'
  end
  scope '/video/request', :controller => 'external/request' do
    get 'new', :as => 'new_video_request'
    get 'video_request_status', :as => 'video_request_status', :path => '/:r_id/status'
    post 'create', :path => '', :as => 'video_request'
  end

end
