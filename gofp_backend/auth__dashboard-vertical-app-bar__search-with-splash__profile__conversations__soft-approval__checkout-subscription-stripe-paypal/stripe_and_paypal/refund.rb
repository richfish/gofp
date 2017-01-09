class Refund < ActiveRecord::Base
  after_create ->{ AccountManager.new(self).issue_refund }
  after_create ->{ UserMailer.delay.general_refund_notice(self) }

  belongs_to :account
  belongs_to :booking_request

end
