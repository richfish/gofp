class UserMailer < ApplicationMailer

  layout 'global_mailer'

  def purhcase_confirmation(order)
    @order = order
    email = order.user.email
    mail(to: email, subject: "Your Monkey Order Confirmation")
  end
end
