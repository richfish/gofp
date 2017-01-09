class ClearExpiredNewBookableAssetJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(bookable_asset_id)
    bookable_asset = BookableAsset.find(bookable_asset_id)
    if bookable_asset.status == BookableAsset::STATUS_NEW && bookable_asset.created_at <= (Time.now - 60.minutes)
      bookable_asset.expire!
    end
  end
end