class PrepareCompleteStatusJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(bookable_asset_id)
    bookable_asset = BookableAsset.find(bookable_asset_id)
    if bookable_asset.confirmed && bookable_asset.status == BookableAsset::STATUS_PENDING
      bookable_asset.complete!
    end
  end
end