class BookableAssetMailer < ActionMailer::Base
  def confirmation_to_customer(bookable_asset)
    @bookable_asset = bookable_asset
    @date = bookable_asset.local_date
    @time = bookable_asset.local_time

    email = bookable_asset.order.email
    mail(to: email, subject: "Your #{@date} - #{@time} OfflineDating BookableAsset Confirmation")
  end

  def bookable_asset_confirmation_for_artist(bookable_asset)
    @bookable_asset = bookable_asset
    date = bookable_asset.local_date
    time = bookable_asset.local_time

    email = bookable_asset.artist.email
    mail(to: email, subject: "New BookableAsset! Confirm for #{date} at #{time}")
  end

  def cancellation_and_refund_notice_to_customer(bookable_asset)
    @bookable_asset = bookable_asset
    @date = bookable_asset.local_date
    @time = bookable_asset.local_time
    @artist_name = bookable_asset.artist.full_name
    email = bookable_asset.customer_email

    mail(to: email, subject: "Cancellation and refund notice for bookable_asset with #{@artist_name} on #{@date}")
  end

  def cancellation_notice_by_artist_to_artist(bookable_asset)
    @bookable_asset = bookable_asset
    @date = bookable_asset.local_date
    @time = bookable_asset.local_time
    @artist_name = bookable_asset.artist.full_name
    email = bookable_asset.artist.email

    mail(to: email, subject: "Cancellation notice for upcoming bookable_asset on #{@date} - #{@time}")
  end

  def customer_cancellation_notice_to_artist(bookable_asset)
    @bookable_asset = bookable_asset
    date = bookable_asset.local_date
    time = bookable_asset.local_time
    @artist_name = bookable_asset.artist.full_name
    email = bookable_asset.artist.email

    mail(to: email, subject: "Cancellation by Customer for BookableAsset on #{date} - #{time}")
  end

  def successful_confirmation_to_artist(bookable_asset)
    @bookable_asset = bookable_asset
    date = bookable_asset.local_date
    time = bookable_asset.local_time
    email = bookable_asset.artist.email
    mail(to: email, subject: "Congrats! You've confirmed and are on for your #{date}-#{time} outing.")
  end
end