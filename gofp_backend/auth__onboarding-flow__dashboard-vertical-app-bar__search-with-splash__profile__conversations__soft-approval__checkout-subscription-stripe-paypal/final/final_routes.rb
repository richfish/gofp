require  "sidekiq/web"

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "welcome#index"

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      post :update_cc
      post :cancel_service
    end
  end

  resources :profiles do
    collection do
      post :profile_image
      patch :profile_image
    end
  end

  resources :orders, only: [:create, :new] do
    collection do
      post :stripe_webhook
      post :paypal_ipn
      get :paypal_confirmation
    end
  end

  resources :site_subscriptions, only: :create

  resources :search_entity_subscriptions, only: :create

  resources :searchable_entities do
    collection do
      get :search
      get :guided_search
    end
  end

  resources :onboardings, only: [:index, :create]

  resources :conversations

  devise_for :users, :controllers => {
      :sessions => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords => "users/passwords",
      :registrations => "users/registrations",
      :unlocks => "users/unlocks",
      :omniauth_callbacks => "users/omniauth_callbacks"
  }
  devise_scope :user do
    get "signup" => "users/registrations#new"
    get "login" => "users/sessions#new"
    get "logout" => "users/sessions#destroy"
    get "login_as" => "users/sessions#login_as"
    get "logout_as" => "users/sessions#logout_as"
    post "users/sign_up" => "users/registrations#new"
    get "confirmation" => "users/confirmations#show"
    get "users/confirmation" => "users/confirmations#show"
  end

  get "policies"                    => "policies#policies_general"
  get "acceptance"                  => "policies#general_acceptance"
  get "logistics"                   => "policies#general_bootcamp_logistics"
  get "cancellations_refunds"       => "policies#general_cancellations_refunds"
  get "disputes_resolutions"        => "policies#general_disputes_resolutions"
  get "payments"                    => "policies#general_payments"
  get "reviews_policy"              => "policies#general_reviews"
  get "provider_policies"           => "policies#provider_general"
  get "provider_auto_cancellations" => "policies#provider_auto_cancellations"
  get "provider_levels"             => "policies#provider_levels"
  get "provider_obligations"        => "policies#provider_obligations"
  get "provider_payouts"            => "policies#provider_payouts"
  get "provider_profile_guidelines" => "policies#provider_profile_guidelines"
  get "provider_reviews_ratings"    => "policies#provider_reviews_ratings"
  get "provider_bootcamp_logistics" => "policies#provider_bootcamp_logistics"
  get "provider_search_visibility"  => "policies#provider_search_visibility"
  get "invite_participants"         => "policies#provider_invite_participants"

  if Rails.env.development?
    get 'color_palette' => 'internal_pages#color_palette'
  end

  if Rails.env.development?
    mount  Sidekiq::Web, at: "/sidekiq"
  else
    authenticate(:admin_user){ mount Sidekiq::Web, at: "/sidekiq" }
  end


end
