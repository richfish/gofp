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
