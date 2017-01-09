require  "sidekiq/web"

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "welcome#index"

  resources :users, only: [:index, :show, :edit, :update] do
    resources :profiles
    resources :bookable_assets do
      get "confirm_bookable_asset" => "bookable_asset_actions#confirm"
      get "revive_bookable_asset" => "bookable_asset_actions#revive"
      post "reject_bookable_asset" => "bookable_asset_actions#reject"
      post "reschedule_bookable_asset" => "bookable_asset_actions#reschedule"
      get "publish" => "bookable_asset_actions#publish"
    end
  end

  #DECIDE IF NEST
  resources :orders

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
  # post "users/:user_id/bookable_assets/:bookable_asset_id/returning_stripe" => "orders#returning_stripe", as: :returning_stripe

  post "image_asset" => "profiles#image_asset"
  patch "image_asset" => "profiles#image_asset"

  post 'paypal_ipn' => "orders#paypal_ipn"
  get 'paypal_confirmation' => "orders#show_paypal_redirect"

  get "policies_customer" => "static_pages#policies_customer"
  get "policies_provider" => "static_pages#policies_provider"
  get "policies_general" => "static_pages#policies_general"
  get "jobs" => "static_pages#jobs"



  #TODO wrap in authentication
  mount Sidekiq::Web, at: "/sidekiq"
end