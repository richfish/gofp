class PromptReviewJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(bookable_asset_id)
    bookable_asset = BookableAsset.find(bookable_asset_id)
    if bookable_asset.status == BookableAsset::STATUS_COMPLETE && BookableAssetTimeManager.new(bookable_asset).end_time_is_in_past?
      ReviewMailer.prompt_review(bookable_asset).deliver
    end
  end

end