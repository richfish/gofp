class ProfileMailer < ApplicationMailer
  before_filter { |record| create_email_record(record) }

  def alert_user_of_profile_issue(profile)
    @profile = profile
    email = profile.user.email
    mail(to: email, subject: "We had an issue with your profile - please correct")
  end

  def publish_notice_to_user(profile)
    @profile = profile
    first_name = profile.first_name
    email = profile.user.email
    mail(to: email, subject: "#{first_name}! You are now published and publicly searchable!")
  end
end