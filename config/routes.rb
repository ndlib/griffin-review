Griffin::Application.routes.draw do

  devise_for :users


  root :to => 'courses#index'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  resources :courses, only: [ 'index', 'create' ] do
    # resources :get_reserves, as: 'get_reserve', only: [ 'show' ]
    #resources :reserves, controller: 'instructor_new_reserves', only: [ 'new', 'create' ]
    # resources :copy_reserves, :path => 'copy', only: [ 'create' ]
    resources :reserves, controller: 'course_reserves', only: ['index', 'show', 'new', 'create', 'destroy']

    get 'copy', to: 'copy_reserves#copy_step1', as: :copy_step1
    get 'copy/:from_course_id', to: 'copy_reserves#copy_step2', as: :copy_step2
    get 'copy/:from_course_id/copy', to: 'copy_reserves#copy', :via => :post, as: :copy


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
