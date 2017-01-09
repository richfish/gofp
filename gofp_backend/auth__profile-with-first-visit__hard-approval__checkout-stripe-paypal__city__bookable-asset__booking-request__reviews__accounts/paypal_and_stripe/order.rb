class Order < ActiveRecord::Base
  before_create ->{ self.euid = UUID.generate }

  after_create ->{ AccountManager.new(self).update_earnings unless bookable_asset_already_has_application? }

  belongs_to :account
  belongs_to :booking_request

  scope :pending_admin_auth_void, ->{ where(capture_rejected: true, admin_auth_voided: false) }

  def admin_void_auth!
    update_column(:admin_auth_voided, true)
    AccountManager.new(self).subtract_capture
  end

  def amount_bookable_asset_cents
    self.participant_amount_cents
  end

  def bookable_asset_already_has_application?
    self.booking_request.booking_asset.unconfirmed?
  end

end
