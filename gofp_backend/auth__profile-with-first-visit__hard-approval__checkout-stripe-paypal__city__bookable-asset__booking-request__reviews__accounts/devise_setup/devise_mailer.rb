class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  include ApplicationHelper


  # before_filter :attach_logo_to_email

  layout "global_mailer"

  def confirmation_instructions(record, token, opts={})
    @user    = record
    @email   = @user.email
    @token   = token
    @subject = "Welcome to Monkey"

    mail to: @user.email, subject: @subject
  end

  def reset_password_instructions(record, token, opts={})
    @user    = record
    @token   = token
    @subject = "Welcome to Monkey"

    mail to: @user.email, subject: @subject
  end

  private

  def attach_logo_to_email
    attachments.inline["a-logo-here.png"] = File.read("#{Rails.root}/app/assets/images/a-logo-here.png")
  end
end
