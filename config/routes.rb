require 'sidekiq/web'

Rails.application.routes.draw do
  root 'static_pages#home'
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, path: ''

  get 'meet' => 'static_pages#meet', as: 'meet'
  get 'faq' => 'static_pages#faq', as: 'faq'

  resources :availabilities
end
