Jobsworth::Application.routes.draw do

  devise_for  :users, 
              :controllers => { :sessions  => "auth/sessions", 
                                :passwords => "auth/passwords" }

  get 'activities/index', as: 'activities'
  root :to => 'activities#index'

  resources :customers do
    member do
      get :show_logo
      post :delete_logo
    end
    collection do
      post :upload_logo
      post :search
    end
  end

  resources :news_items,  :except => [:show]
  resources :projects,    :except => [:show]
  resources :tasks,       :except => [:show]

  post "project_files/upload" => "project_files#upload"
  get "project_files/list" => "project_files#list"
  post "tasks/change_task_weight" => "tasks#change_task_weight"
  get "tasks/nextTasks/:count" => "tasks#nextTasks", :defaults => { :count => 5 }

  resources :resources do
    collection do
      get :attributes
      get :auto_complete_for_resource_parent
    end
    get :show_password, :on => :member
  end

  resources :resource_types do
    collection do
      get :attribute
    end
  end

  resources :organizational_units

  resources :pages do
    collection do
      get :target_list
    end
  end

  resources :task_filters do
    get :toggle_status, :on => :member
    match :select, :on => :member
    collection do
      get :manage
      get :recent
      get :reset
      get :search
      get :update_current_filter
      get :set_single_task_filter
    end
  end

  resources :todos do
    match :toggle_done, :on => :member
  end

  resources :work_logs do 
    match :update_work_log, :on=> :member
  end

  resources :tags do
    collection do
      get :auto_complete_for_tags
    end
  end

  resources :work do
    collection do
      get :start
      get :stop
      get :cancel
      get :pause
    end
  end

  resources :properties
  resources :scm_projects
  resources :triggers

  match 'api/scm/:provider/:secret_key' => 'scm_changesets#create'
  match ':controller/service.wsdl', :action => 'wsdl'

  match "tasks/view/:id" => "tasks#edit", :as => :task_view

  get 'projects/:id/ajax_add_permission'      => 'projects#ajax_add_permission'

  resources :projects, :companies, :customers, :property_values do
    resources :score_rules
  end

  get 'tasks/score/:task_num' => 'tasks#score'

  match ':controller/list' => ':controller#index'

  match ":controller(/:action(/:id(.:format)))"
end
