Rails.application.routes.draw do

  resources :text_blocks, only: [:index]
  get '/search', to: 'text_blocks#search'
  root 'admin/supergroups#index'
  devise_for :users

  namespace :admin do
    resources :supergroups, :groups, :text_blocks, :authors, :fields, :genres, :publishings, :types, :translators
    resources :collections do
      get 'new_text_blocks', on: :member
      post 'create_text_blocks', on: :member
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
