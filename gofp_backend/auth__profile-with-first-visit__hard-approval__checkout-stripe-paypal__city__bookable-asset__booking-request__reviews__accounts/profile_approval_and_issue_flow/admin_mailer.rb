class AdminMailer < ApplicationMailer

  def approval_notice(profile)
    @profile = profile
    full_name = profile.full_name
    mail(to: "richard@monkey.com", subject: "nneds approval notice for #{full_name}")
  end

end
