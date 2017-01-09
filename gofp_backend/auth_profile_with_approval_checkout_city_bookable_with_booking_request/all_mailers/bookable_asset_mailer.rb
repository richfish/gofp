class BootcampMailer < ApplicationMailer
  def new_booking_request_email_to_provider(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @bookable_asset.user.email
    mail(to: email, subject: "New Application for #{@bookable_asset.name}")
  end

  def booking_request_confirmation_email_to_customer(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @booking_request.order.email.presence || @booking_request.email
    mail(to: email, subject: "Confirmation of Submitted Request and Payment Authorization")
  end

  def confirmed_message_to_provider(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @bookable_asset.user.email
    mail(to: email, subject: "Congrats you've confirmed your participant!")
  end

  def confirmed_message_to_customer(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @booking_request.email
    mail(to: email, subject: "Congrats you're all booked!")
  end

  def cancellation_and_auth_void_notice_to_customer(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @booking_request.email
    mail(to: email, subject: "Your instructor is unable to do this bootcam")
  end

  def rejection_or_expiration_notice_to_provider(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    email = @bookable_asset.user.email
    mail(to: email, subject: "Notice - You have rejected an booking_request or it has expired after 48 hours.")
  end

  def joint_intro_email_after_confirmation(booking_request)
    @booking_request = booking_request
    @bookable_asset = booking_request.bookable_asset
    @name_provider = @bookable_asset.user.profile.first_name
    @name_customer = @booking_request.first_name
    email_provider = @bookable_asset.user.email
    email_customer = @booking_request.email
    mail(to: [email_provider, email_customer], subject: "#{@name_provider} meet #{@name_customer}, #{@name_customer} meet #{@name_provider}")
  end

  def customer_and_provider_cancellation_or_stop_notice(bookable_asset)
    @bookable_asset = bookable_asset
    @booking_request = bookable_asset.booking_requests.accepted.first
    guest_email = @booking_request.email
    provider_email = @bookable_asset.user.email
    mail(to: [guest_email, provider_email], subject: "Confirmation notice, your Bootcamp++ has been cancelled or stopped.")
  end


end