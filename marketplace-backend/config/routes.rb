Rails.application.routes.draw do
  get "users/new"
  get "users/create"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  get    'login',  to: 'sessions#new'
  get '/auth/google_oauth2', to: 'sessions#google_auth', as: :google_login
 

  # Google account authentication routes
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy' 

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Set the root path to redirect based on authentication status
  root 'home#index'

  resources :courses do
    collection do
      get 'search'
    end
  end

  # Saved classes (enrollments)
  get 'saved_classes', to: 'enrollments#index'
  delete 'enrollments/:id', to: 'enrollments#destroy', as: :enrollment
  post 'enrollments', to: 'enrollments#create', as: :enrollments

  # Swipes
  get 'swipes', to: 'courses#swipes', as: :swipes

  # Account management (optional if users can sign up)
  resources :users, only: [:new, :create]

  # Defines the root path route ("/")
  # root "posts#index"
end
