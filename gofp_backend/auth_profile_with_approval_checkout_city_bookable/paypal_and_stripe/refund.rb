#THIS DOESNT ACTUALLY ISSUE REFUND, JUST A RECORD, UPDATES ARTIST ACCOUNT
#RULE: NO REFUNDS SHOULD INCLUDE OUR FEE, UNLESS IT IS A FULL REFUND FROM THE ARTIST CANCELLING
class Refund < ActiveRecord::Base
  #Customize
  #before_create ->{ self.account = self.booking.artist.account }

  #after_create ->{ AccountManager.new(self).issue_refund }
  #after_create ->{ UserMailer.delay.general_refund_notice(self) }

  belongs_to :account

end
