class User < ActiveRecord::Base
  LEVEL_BEGINNER = 1
  LEVEL_ADVANCED = 2
  LEVEL_TRUSTED = 3
  LEVEL_POWER = 4

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_create ->{ AccountManager.allocate_account(self) }

  after_save ->{ raise Exceptions::InvalidCity if self.city_changed? && CityConformityPolicy.illegal_city?(self.city) }

  has_one :account
  has_one :profile, dependent: :destroy
  has_one :avatar, class_name: 'Asset', :as => :owner, dependent: :destroy
  has_many :bookable_assets

  validates_presence_of :city

  scope :for_city, ->(city){ where(city: city) }

  def current_booking_requests
    #TODO sql
    self.bookable_assets.map{ |x| x.booking_requests }.flatten.select{ |y| y.paid? }
  end

  def needs_prompting_for_paypal?
    self.bookable_assets.present? && self.paypal_email.blank?
  end

  def full_name
    self.profile.presence ? [profile.first_name, profile.last_name].join(" ") : "No Profile"
  end

  def first_name
    self.profile.try(:first_name )
  end

  def last_name
    self.profile.try(:last_name )
  end

  def no_reviews_yet?
    self.reviews_count == 0 || self.reviews_count.nil?
  end

  def can_create_another_bookable_asset?
    #self.bookable_assets.current.count < 2
    true
  end

  def notify_for_paypal_email?
    bcs = self.bookable_assets
    bcs.past.exists? || bcs.bookable_and_current.exists? ||
    (bcs.unpublished.exists? && bcs.unpublished.any?{|x| x.publishable?})
  end

  def update_various_avg_ratings
    reviews =  Review.for_user(self).acknowledged
    self.avg_overall = reviews.average(:overall)
    self.avg_value_of_experience = reviews.average(:value_of_experience)
    self.avg_satisfaction = reviews.average(:satisfaction)
    self.avg_teaching_ability = reviews.average(:teaching_ability)
    self.save
  end

end
