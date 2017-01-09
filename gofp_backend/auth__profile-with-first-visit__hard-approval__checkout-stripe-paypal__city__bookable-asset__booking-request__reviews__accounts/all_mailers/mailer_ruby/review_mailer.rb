class ReviewMailer < ApplicationMailer
  #before_filter { |record| create_email_record(record) }

  def prompt_review(bookable_asset)
    @bookable_asset = bookable_asset
    @booking_request = bookable_asset.booking_requests.accepted.first
    email = @booking_request.email
    mail(to: email, subject: "Please Review your Bootcamp++ with #{@bookable_asset.user.first_name}")
  end

  def acknowledged_confirmation_to_provider(review)
    @review = review
    @bookable_asset = review.bookable_asset
    @booking_request = @bookable_asset.booking_requests.accepted.first
    email = @bookable_asset.user.email

    mail(to: email, subject: "You have a new review from #{@booking_request.first_name}")
  end
end