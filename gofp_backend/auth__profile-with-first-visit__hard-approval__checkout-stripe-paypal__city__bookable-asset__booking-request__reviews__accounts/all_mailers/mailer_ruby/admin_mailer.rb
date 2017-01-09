class AdminMailer < ApplicationMailer

  def acknowledge_review(review)
    @review = review
    @bookable_asset = review.bookable_asset
    mail(to: "richard@monkey.com", subject: "ATTN - review needs to be acknowledged: #{review.overall} rating for uesr_id #{@bookable_asset.user.id}")
  end

  def approval_notice(profile)
    @profile = profile
    full_name = profile.full_name
    mail(to: "richard@monkey.com", subject: "ATTN - needs approval notice for #{full_name}")
  end

  def booking_request_expired_release_the_auth(booking_request)
    @order = booking_request.order
    mail(to: "richard@monkey.com", subject: "ATTN - booking_request expired, release the auth")
  end

  def review_prompt_rejected(bookable_asset)
    @bookable_asset = bookable_asset
    mail(to: "richard@monkey.com", subject: "ATTN - error - Review Prompt Rejected")
  end

  def alert_order_needs_to_be_captured(order)
    @order = order
    mail(to: "admin@monkey.com", subject: "ATTN - capture this order")
  end

  def alert_order_capture_rejected(order)
    @order = order
    mail(to: "admin@monkey.com", subject: "ATTN - order rejected, release the auth")
  end

  def may_need_partial_refund_for_midway_stop(bookable_asset)
    @bookable_asset = bookable_asset
    mail(to: "richard@monkey.com", subject: "ATTN - PARTIAL REFUND MIDWAY STOP?")
  end

  def may_need_partial_refund_for_provider_cancelled(bookable_asset)
    @bookable_asset = bookable_asset
    mail(to: "richard@monkey.com", subject: "ATTN - PARTIAL REFUND PROVIDER CANCELLED?")
  end

  def may_need_partial_refund_for_customer_cancelled(bookable_asset)
    @bookable_asset = bookable_asset
    mail(to: "richard@monkey.com", subject: "ATTN - PARTIAL REFUND CUSTOMER CANCELLED?")
  end

  def followup_on_rejection_of_user(profile)
    @profile = profile
    mail(to: "richard@monkey.com", subject: "ATTN - REminder to follow up with reject user/profile.")
  end

end
