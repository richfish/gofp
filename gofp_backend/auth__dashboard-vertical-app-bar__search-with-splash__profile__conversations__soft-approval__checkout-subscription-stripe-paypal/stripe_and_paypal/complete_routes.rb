require  "sidekiq/web"

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "welcome#index"

  resources :users, only: [:index, :show, :edit, :update]

  #DECIDE IF WANT TO NEST
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
  # post "users/:user_id/bookings/:booking_id/returning_stripe" => "orders#returning_stripe", as: :returning_stripe
  post 'paypal_ipn' => "orders#paypal_ipn"
  get 'paypal_confirmation' => "orders#show_paypal_redirect"


  #TODO wrap in authentication
  mount Sidekiq::Web, at: "/sidekiq"
end
