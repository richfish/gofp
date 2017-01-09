class User < ActiveRecord::Base

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_create ->{ AccountManager.allocate_account(self) }

  after_save ->{ raise Exceptions::InvalidCity if self.city_changed? && CityConformityPolicy.illegal_city?(self.city) }

  has_one :account
  has_one :profile, dependent: :destroy

  validates_presence_of :city

  scope :for_city, ->(city){ where(city: city) }

  def full_name
    #CUSTOMIZE
    # if is_artist?
    #   profile.try(:full_name)
    # elsif is_customer?
    #   self.proto_user.full_name
    # end
  end

  def first_name
    #CUSTOMIZE
    # if is_artist?
    #   profile.try(:first_name)
    # elsif is_customer?
    #   self.proto_user.first_name
    # end
  end

end

