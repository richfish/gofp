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

  get "summary_cards_1" => "templates#summary_cards_1"
  get "summary_cards_2" => "templates#summary_cards_2"
  get "summary_cards_3" => "templates#summary_cards_3"
  get "summary_cards_4" => "templates#summary_cards_4"
  get "summary_cards_5" => "templates#summary_cards_5"
  get "splash_page_cards_1" => "templates#splash_page_cards_1"
  get "splash_page_full_1" => "templates#splash_page_full_1"
  get "splash_page_full_2" => "templates#splash_page_full_2"
  get "splash_page_full_3" => "templates#splash_page_full_3"


  get 'color_palette' => 'internal_pages#color_palette'
  get 'color_palette_md' => 'internal_pages#color_palette_md'

  if Rails.env.development?
    mount  Sidekiq::Web, at: "/sidekiq"
  else
    authenticate(:admin_user){ mount Sidekiq::Web, at: "/sidekiq" }
  end
end
