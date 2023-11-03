Rails.application.routes.draw do
  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations'
    }

    namespace :auth do
      resources :users, only: [:update, :index, :show], defaults: { format: 'json' }
      resources :users, except: [:create, :destroy]
    end

    resources :recruitments do
      resources :sports_disciplines, only: [:index], controller: 'recruitment_sports_disciplines'
      resources :target_ages, only: [:index], controller: 'recruitment_target_ages'
    end
    resources :teams do
      resources :sports_disciplines, only: [:index], controller: 'team_sports_disciplines'
      resources :target_ages, only: [:index], controller: 'team_target_ages'
    end
    resources :target_ages
    resources :sports_types
    resources :sports_disciplines
    resources :prefectures
    resources :chat_rooms
    resources :chat_messages
  end
end
