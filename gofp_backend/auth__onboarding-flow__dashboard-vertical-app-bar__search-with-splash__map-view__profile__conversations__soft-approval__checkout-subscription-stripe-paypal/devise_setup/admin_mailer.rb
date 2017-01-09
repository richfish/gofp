class AdminMailer < ApplicationMailer

  def alert_of_sale    
    mail(to: "rifisherr@gmail", subject: "Monkey Subscription Purhcase")
  end
end
