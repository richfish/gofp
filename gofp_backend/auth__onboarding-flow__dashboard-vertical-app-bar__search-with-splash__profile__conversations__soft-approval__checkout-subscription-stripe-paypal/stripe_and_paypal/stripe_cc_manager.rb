class StripeCcManager

  attr_accessor :stripe_cus, :stripe_cc, :stripe_subscription

  def initialize(user)
    @stripe_cus = retrieve_stripe_customer user
    @stripe_cc = retrieve_default_card user
    @stripe_subscription = retrieve_customer_subscription
  end

  def self.retrieve_customer_from_webhook(params)
    cus_id = params[:data][:object][:customer]
    Stripe::Customer.retrieve(cus_id)
  end

  def last_four_digits
    stripe_cc.last4
  end

  def replace_card!(params)
    old_cc_id = stripe_cus.default_source
    stripe_token = params[:stripeToken]
    stripe_cus.sources.create(source: stripe_token)
    stripe_cus.sources.retrieve(old_cc_id).delete
  end

  def cancel_subscription!
    if stripe_subscription.count > 1
      stripe_subsription.each(&:delete)
    else
      stripe_subscription.first.delete
    end
  end

  def add_another_subscription!
    stripe_subscription.create(plan: "3_for_10_subscription")
  end


  private

  def retrieve_stripe_customer(user)
    customer_id = user.orders.active.first.stripe_customer_hash
    Stripe::Customer.retrieve(customer_id)
  end

  def retrieve_default_card(user)
    cc_id = stripe_cus.default_source
    stripe_cus.sources.retrieve(cc_id)
  end

  def retrieve_customer_subscription
    stripe_cus.subscriptions
  end

end
