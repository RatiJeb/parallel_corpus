Rails.application.routes.draw do

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/, defaults: { locale: 'ka' } do
    resources :text_blocks do
      get 'search', on: :collection
      get 'advanced_search', on: :collection
    end
    resources :collocations, only: [:index]
    root 'text_blocks#index'
    resources :contacts, only: %i[index create]
    devise_for :users, controllers: { invitations: 'users/invitations' }

    namespace :admin do
      root 'supergroups#index'
      resources :supergroups, :groups, :authors, :fields, :genres, :publishing, :types, :translators, :users
      resources :languages, only: :create
      resources :collections do
        get 'export', on: :collection
        get 'new_text_blocks', on: :member
        post 'create_text_blocks', on: :member
      end
      resources :text_blocks do
        get 'export', on: :collection
        get 'edit_multiple', on: :collection
        delete 'destroy_multiple', on: :collection
        put 'update_multiple', on: :collection
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
