class Review < ActiveRecord::Base
  STAR_OPTIONS = [1,2,3,4,5]

  before_create :validate_not_later_than_7_days

  after_create { AdminMailer.delay.acknowledge_review(self) }

  after_save :update_various_avg_ratings, if: :just_acknowledged?
  after_save { ReviewMailer.delay.acknowledged_confirmation_to_provider(self) if just_acknowledged? }

  after_destroy :update_various_avg_ratings #these shouldn't get destroyed anyways

  belongs_to :bookable_asset
  belongs_to :user, counter_cache: true
  has_one :comment, as: :commentable, dependent: :destroy

  validates_inclusion_of :teaching_ability, :overall, :value_of_experience, :satisfaction, in: STAR_OPTIONS
  validates_presence_of :bookable_asset, :synopsis

  scope :acknowledged, ->{ where(acknowledged: true) }
  scope :for_user, ->(user){ where("reviews.user_id" => user.id, flagged: false) }

  def validate_not_later_than_7_days
    if BootcampTimeManager.new(self.bookable_asset).hours_since_booking_ended > (24*7 + 1) #extra padding if started review right at boundary
      raise Exceptions::ReviewTooLate
    end
  end

  def update_various_avg_ratings
    self.user.update_various_avg_ratings
  end

  def just_acknowledged?
    self.acknowledged_changed? && self.acknowledged
  end

end