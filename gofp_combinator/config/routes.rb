require  "sidekiq/web"

Rails.application.routes.draw do

  root "welcome#index"

  resources :site_subscriptions

  get "policies" => "policies#general"
  get "policies_sleeping" => "policies#sleeping"
  get "policies_alerts" => "policies#alerts"
  get "policies_failure" => "policies#failure"
  get "policies_geography" => "policies#geography"
  get "policies_monitoring" => "policies#monitoring"
  get "policies_grandfathering" => "policies#grandfathering"
  get "policies_faq" => "policies#faq"
  get "policies_payments" => "policies#payments"
  get "policies_cancellation" => "policies#cancellation"
  get "policies_the_texts" => "policies#the_texts"


  post "generate_app" => "welcome#generate_app"


  if Rails.env.development?
    get 'color_palette' => 'internal_pages#color_palette'
    get 'color_palette_md' => 'internal_pages#color_palette_md'
  end

  if Rails.env.development?
    mount  Sidekiq::Web, at: "/sidekiq"
  else
    authenticate(:admin_user){ mount Sidekiq::Web, at: "/sidekiq" }
  end
end
