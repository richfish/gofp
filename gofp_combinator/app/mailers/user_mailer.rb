class UserMailer < ApplicationMailer

  layout 'global_mailer'

  def notify_cancelled_subscription(user)
    @user = user
    mail(to: user.email, subject: "Service Cancellation Notice")
  end

  def subscription_confirmation(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: "Your Monkey Order Confirmation")
  end

end
