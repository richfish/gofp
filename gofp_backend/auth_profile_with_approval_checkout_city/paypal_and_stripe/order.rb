class Order < ActiveRecord::Base
  belongs_to :account

  before_create ->{ self.order_key = UUID.generate }
  #CUSTOMIZE
  #before_create ->{ self.account = self.booking.artist.account }

  #CUSTOMIZE
  #after_create ->{ AccountManager.new(self).update_earnings unless self.beer }
end
