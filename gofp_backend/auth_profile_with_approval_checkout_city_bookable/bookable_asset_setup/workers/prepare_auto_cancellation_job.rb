class PrepareAutoCancellationJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  #may want to add an email notification to the artist
  def perform(bookable_asset_id)
    bookable_asset = BookableAsset.find(bookable_asset_id)
    unless bookable_asset.confirmed
      bookable_asset.status = BookableAsset::STATUS_ARTIST_CANCELLED
      bookable_asset.save
    end
  end
end