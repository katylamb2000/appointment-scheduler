require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  root 'static_pages#home'
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, path: '', controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :students, path: '', controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :admins, path: '', controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  get '/user/:id/profile_photo_processing' => 'users#profile_photo_processing'

  get 'meet' => 'static_pages#meet', as: 'meet'
  get 'faq' => 'static_pages#faq', as: 'faq'

  resources :availabilities
  resources :appointments, only: [:index, :show, :update]
  resources :student_materials, only: [:update]
  get 'dashboard' => 'users#student_dashboard', as: 'student_dashboard'
  post 'charges' => 'charges#create'

  scope :api, :v1 do
    get '/availabilities' => 'api/v1/availabilities#index'
  end
end
