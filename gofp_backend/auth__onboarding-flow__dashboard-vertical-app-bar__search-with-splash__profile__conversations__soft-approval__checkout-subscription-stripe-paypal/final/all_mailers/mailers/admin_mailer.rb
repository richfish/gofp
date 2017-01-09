class AdminMailer < ApplicationMailer

  def alert_of_sale
    mail(to: "rifisherr@gmail", subject: "Monkey Subscription Purhcase")
  end

  def approval_heads_up(profile)
    @profile = profile
    full_name = profile.full_name
    mail(to: "richard@monkey.com", subject: "approval heads up for #{full_name}")
  end

end
