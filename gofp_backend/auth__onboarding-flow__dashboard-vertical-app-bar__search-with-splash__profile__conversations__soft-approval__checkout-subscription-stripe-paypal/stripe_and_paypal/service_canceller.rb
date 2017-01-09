class ServiceCanceller
  def initialize(user)
    @user = user
  end

  def cancel_stripe_subscription
    StripeCcManager.new(@user).cancel_subscription!
  end

  def update_application_objs
    @user.orders.update_all(unsubscribed: true)
    @user.checks.update_all(deactive: true)
  end

  def update_available_checks
    @user.update_attribute(:available_checks_count, 0)
  end

end
