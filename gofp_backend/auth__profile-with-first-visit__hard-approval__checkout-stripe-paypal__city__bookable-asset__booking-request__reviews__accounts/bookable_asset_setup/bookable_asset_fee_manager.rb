class BookableAssetFeeManager
  attr_accessor :bookable_asset, :fee, :total_amount, :total_amount_for_paypal

  def initialize(bookable_asset)
    @bookable_asset = bookable_asset
    @fee = service_fee_for_bookable_asset_cents
    @total_amount = total_bookable_asset_cost_cents
    @total_amount_for_paypal = total_amount_for_paypal
  end

  def bookable_asset_cost_minus_fee
    fee = service_fee_for_bookable_asset_cents
    @bookable_asset.amount_cents.to_i - fee
  end

  def total_bookable_asset_cost_cents
    fee = service_fee_for_bookable_asset_cents
    fee + @bookable_asset.amount_cents.to_i
  end

  def total_amount_for_paypal
    total_bookable_asset_cost_cents/100
  end

  def service_fee_for_bookable_asset_cents
    (@bookable_asset.amount_cents.to_f * (ADMINISTRATIVE_SETTINGS[:fee][:percentage]/100))
  end
end