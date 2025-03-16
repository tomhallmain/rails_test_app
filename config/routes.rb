Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Configure Devise routes
  devise_for :users

  # Mount RailsAdmin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Defines the root path route ("/")
  root "projects#index"

  # Archives routes
  get '/archives', to: 'tasks#archive_index', as: :archives
  post '/archives/bulk', to: 'tasks#bulk_archive', as: :bulk_archive

  # Reschedule routes
  get '/reschedule', to: 'tasks#reschedule_index', as: :reschedule
  post '/reschedule/bulk', to: 'tasks#bulk_reschedule', as: :bulk_reschedule

  resources :projects do
    resources :tasks, shallow: true
  end

  resources :tasks do
    member do
      patch :toggle
      post :archive
    end
    resources :comments, only: [:create, :destroy], shallow: true
  end

  resources :tags, except: [:show]
end
