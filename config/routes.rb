# config/routes.rb
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_ADMIN_USER'])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_ADMIN_PASSWORD']))
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount ActionCable.server => '/cable'
  namespace 'api' do
    namespace 'v1' do
      resources :lists, only: [:index, :show]
      resources :tokens, only: [:index]
      resources :currencies, only: [:index]
      resources :banks, only: [:index]
      resources :payment_methods, only: [:index]
      resources :orders, only: [:index, :create, :show] do
        patch :cancel, on: :member
        resources :disputes, only: [:create]
      end
      resources :users, only: [:show]
      resources :user_profiles, only: [:show, :update]
      resources :quick_buy, only: [:index]
      resources :list_management, only: [:create, :update, :destroy, :index]
      resources :merchants, only: [:index]
      resources :settings, only: [:index]
      get '/airdrop/:address/:round', to: 'airdrops#index'
      post '/user_profiles/verify/:chain_id', to: 'user_profiles#verify'
      get '/layer3/account', to: 'layer3#account'
      get '/layer3/ad', to: 'layer3#ad'
      get '/layer3/ordered', to: 'layer3#ordered'
      get '/prices/:token/:fiat', to: 'prices#show'
      get '/user_search/:id', to: 'user_search#show'
      
      # New routes for user relationships
      resources :user_relationships, only: [:index] do
        collection do
          post ':relationship_type/:target_user_id', action: :create
          delete ':relationship_type/:target_user_id', action: :destroy
        end
      end
    end

    get '/webhooks', to: 'webhooks#index'
    post '/webhooks', to: 'webhooks#create'
    post '/webhooks/escrows', to: 'webhooks#escrows'
    get '/blast/webhooks', to: 'blast_webhooks#index'
    post '/blast/webhooks', to: 'blast_webhooks#create'
    post '/blast/webhooks/escrows', to: 'blast_webhooks#escrows'
    post '/telegram/webhook', to: 'telegram#webhook'
  end
end