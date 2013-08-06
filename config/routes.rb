Griffin::Application.routes.draw do

  devise_for :users

  root :to => 'homepage#index'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  resources :courses, only: [ 'index', 'create' ] do

    resources :reserves, controller: 'course_reserves', only: ['index', 'show', 'new', 'create', 'destroy']

    get 'copy', to: 'copy_reserves#copy_step1', as: :copy_step1
    get 'copy/:from_course_id', to: 'copy_reserves#copy_step2', as: :copy_step2
    get 'copy/:from_course_id/copy', to: 'copy_reserves#copy', :via => :post, as: :copy


    get 'copy_old_reserves', to: 'copy_old_reserves#new'
    post 'copy_old_reserves', to: 'copy_old_reserves#create'

    resources :topics, as: 'reserve_topic', path: 'update_topics', only: [ 'update' ]
  end

  post 'sakai_redirect', controller: 'sakai_integrator', path: '/sakai'

  resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]


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
