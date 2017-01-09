class SearchEntitySubscription < ActiveRecord::Base
  #no two sign ups alloewd
  validates_presence_of :email, :city, :technology
  validates_format_of :email, with:  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validate :no_duplicate_email_city_and_technology

  # scope :for_city, ->(city){ where(city: city) }
  # scope :for_technology, ->(technology){ where(technology: technology) }
  scope :for_email, ->(email){ where(email: email) }

  def no_duplicate_email_city_and_technology
    if SearchEntitySubscription.for_email(self.email).exists?
      errors.add(:base, "You have already subscribed to this search entity alert.")
    end
  end

end
