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
      resources :reserves, controller: 'course_reserves', only: ['index', 'show', 'new', 'create', 'destroy']

      get 'streaming/:token/:id', to: "streaming#show"
      get 'streaming/test', to: "streaming#test"

      get 'copy', to: 'copy_reserves#copy_step1'
      get 'copy/:from_course_id', to: 'copy_reserves#copy_step2'
      post 'copy/:from_course_id/copy', to: 'copy_reserves#copy'
      get 'copy_old_reserves', to: 'copy_old_reserves#new'
      post 'copy_old_reserves', to: 'copy_old_reserves#create'
      resources :users, controller: 'course_users', only: [:new, :create, :index, :destroy]
    end

    resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]
  end

  course_routes

  post 'sakai_redirect', controller: 'sakai_integrator', path: '/sakai'
  scope path: '/sakai', :as => 'sakai' do
    course_routes
  end

  resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]

  scope '/documentation' do
    get '/', to: 'documentation#index'
    get '/troubleshooting', to: 'documentation#troubleshooting'
  end


  scope '/admin' do
    resources :requests
    resources :meta_datas, controller: 'requests_meta_data'
    resources :fair_use, controller: 'requests_fair_use'
    resources :resources, controller: 'requests_resources'
#    resources :admin_courses
    resources :semesters, controller: 'semesters'
    resources :scipt, controller: 'script'

    # NOTE About this route.
    # the "ids" that are searched on can have "." in them and that throws off the rails routing. They need to be passed in as
    # query params and not as part of the get string that is not /discovery_test_id/i,adf.adsfwe.adsfsdf but as /discovery_test_id?id=i,adf.adsfwe.adsfsdf
    get "discovery_id_test", to: 'discovery_id_test#show'
    #resources :discovery_id_test, contorller: 'discovery_id_test'
  end

  get "video/request/new", to: "homepage#index"

end
