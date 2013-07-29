Griffin::Application.routes.draw do

  devise_for :users

  root :to => 'courses#index'

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


  resources :archived_courses, controller: 'user_archive_course_listings', only: [ 'index' ]


  scope '/admin' do
    resources :requests
    resources :meta_datas, controller: 'requests_meta_data'
    resources :fair_use, controller: 'requests_fair_use'
    resources :resources, controller: 'requests_resources'
#    resources :admin_courses
    resources :semesters
  end


end
