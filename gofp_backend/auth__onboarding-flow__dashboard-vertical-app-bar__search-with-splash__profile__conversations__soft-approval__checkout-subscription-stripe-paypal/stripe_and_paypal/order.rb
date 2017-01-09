class Order < ActiveRecord::Base

  before_create ->{ self.euid = UUID.generate }
  after_create ->{ UserMailer.delay.subscription_confirmation(self) }
  after_create ->{ AdminMailer.delay.alert_of_sale }

  belongs_to :user

  scope :active, ->{ where(unsubscribed: [nil, false]) }

end
