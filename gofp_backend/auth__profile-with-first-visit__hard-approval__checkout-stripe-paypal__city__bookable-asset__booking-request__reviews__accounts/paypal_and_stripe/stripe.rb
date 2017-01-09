if Rails.env.development?
  Rails.configuration.stripe = {
      :publishable_key => '123',
      :secret_key      => '456'
  }
else
  Rails.configuration.stripe = {
      :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
      :secret_key      => ENV['STRIPE_SECRET_KEY']
  }

end

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# heroku config:set STRIPE_PUBLISHABLE_KEY=123 -a fichte-staging
# heroku config:set STRIPE_SECRET_KEY=456 -a fichte-staging