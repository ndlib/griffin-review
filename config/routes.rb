Griffin::Application.routes.draw do

  devise_for :users

  root :to => 'homepage#index'

  get '404', to: 'errors#catch_404'
  get '500', to: 'errors#catch_500'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  resources :errors

  # this method exits so that several routes that perform the same function
  # can be encapsulated at different places but located once in the routes file
  def course_routes
    resources :courses, controller: 'courses', only: [ 'index', 'create' ] do
      resources :reserves, controller: 'course_reserves', only: ['index', 'show', 'new', 'create', 'destroy'] do
        get 'sipx_redirect', to: 'sipx_redirect#resource_redirect'
      end

      get 'streaming/:token/:id', to: "streaming#show"
      get 'streaming/test', to: "streaming#test"

      get 'copy', to: 'copy_reserves#copy_step1'
      get 'copy/:from_course_id', to: 'copy_reserves#copy_step2'
      post 'copy/:from_course_id/copy', to: 'copy_reserves#copy'
      get 'copy_old_reserves', to: 'copy_old_reserves#new'
      post 'copy_old_reserves', to: 'copy_old_reserves#create'
      resources :users, controller: 'course_users', only: [:new, :create, :index, :destroy]

      get 'sipx_redirect', to: 'sipx_redirect#resource_redirect'
      get 'sipx_admin_redirect', to: 'sipx_redirect#admin_redirect'
    end

    resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]
  end

  course_routes

  post 'sakai_redirect', controller: 'sakai_integrator', path: '/sakai'
  scope path: '/sakai', :as => 'sakai' do
    course_routes
  end

  get 'documentation/troubleshooting', to: 'documentation#troubleshooting'
  get 'documentation/getting_started', to: 'documentation#getting_started'
  get 'getting_started', to: 'documentation#getting_started'

  resources :documentation


  resources :documentation_admin


  scope '/admin' do
    resources :requests
    resources :on_order, controller: 'requests_on_order'
    resources :resync, controller: 'requests_resync', only: ['update']
    resources :meta_datas, controller: 'requests_meta_data'
    resources :fair_use, controller: 'requests_fair_use'
    resources :resources, controller: 'requests_resources'
    resources :types, controller: 'requests_type', only: ['update', 'edit']
    resources :libraries, controller: 'requests_library', only: ['update']
    resources :needed_by, controller: 'requests_needed_by', only: ['update']
    resources :fix_missing_course, controller: 'requests_fix_missing_courses', only: ['update', 'edit']

    resources :semesters, controller: 'semesters'
    get 'semesters/csv/:semester_id', controller: 'semesters', action: :csv_report, as: 'csv_report'
    resources :scipt, controller: 'script'

    resources :users

    # NOTE About this route.
    # the "ids" that are searched on can have "." in them and that throws off the rails routing. They need to be passed in as
    # query params and not as part of the get string that is not /discovery_test_id/i,adf.adsfwe.adsfsdf but as /discovery_test_id?id=i,adf.adsfwe.adsfsdf
    get "discovery_id_test", to: 'discovery_id_test#show'
  end

  resources :realtime_availability

  resource :report_problem

  get "video/request/new", to: "homepage#index"
  get "jwtest", to: 'jwtest#index'
end
