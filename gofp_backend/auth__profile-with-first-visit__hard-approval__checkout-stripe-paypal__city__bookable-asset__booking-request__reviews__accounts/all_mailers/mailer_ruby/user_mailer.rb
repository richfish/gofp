class UserMailer < ApplicationMailer
  def general_refund_notice(refund)
    @bookable_asset = refund.bookable_asset
    @refund = refund
    email = bookable_asset.user.email
    mail(to: email, subject: "Monkey has officially issued a refund")
  end
end