Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :device_tokens
  resources :devices
  devise_for :users
  resources :document_pages
  resources :documents do
    member do
      get "download"
      get "download_fax_quality"
    end
  end
  resources :correspondences
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post "api/v1/documents", to: "device_api#create_document"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
