require  "sidekiq/web"

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "welcome#index"

  resources :users, only: [:index, :show, :edit, :update] do
    resources :profiles
  end

  #DECIDE IF NEST
  resources :orders

  #DECIDE IF NEST
  # resources :profiles

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

  #CUSTOMIZE
  # post "users/:user_id/bookings/:booking_id/returning_stripe" => "orders#returning_stripe", as: :returning_stripe

  post "profile_image" => "profiles#profile_image"
  patch "profile_image" => "profiles#profile_image"

  post 'paypal_ipn' => "orders#paypal_ipn"
  get 'paypal_confirmation' => "orders#show_paypal_redirect"

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

  get 'color_palette' => 'internal_pages#color_palette'

  #TODO wrap in authentication
  mount Sidekiq::Web, at: "/sidekiq"
end
