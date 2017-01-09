class BookingRequest < ActiveRecord::Base
  STATUS_NEW = :new.to_s
  STATUS_PAID = :paid.to_s
  STATUS_REJECTED = :rejected.to_s
  STATUS_EXPIRED = :expired.to_s
  STATUS_ACCEPTED = :accepted.to_s
  #completed
  #customer_cancelled
  #provider_cancelled
  #midway_stop

  before_create ->{ self.euid = UUID.generate }

  before_save :validate_date_falls_on_bookable_asset_schedule

  after_save :paid_actions, if: -> { status_changed_to? STATUS_PAID }
  after_save :expiration_actions, if: ->{ status_changed_to? STATUS_EXPIRED }
  after_save :rejection_actions, if: -> { status_changed_to? STATUS_REJECTED }
  after_save :accept_actions, if: -> { status_changed_to? STATUS_ACCEPTED }

  belongs_to :bookable_asset
  has_one :order
  has_one :refund

  attr_accessor :email_confirm

  validates_presence_of :linkedin_profile, :background, :hopeful_gains
  validates_format_of :linkedin_profile, with: /linkedin.com/
  validates_format_of :linkedin_profile, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  validate :bookable_asset_in_bookable_state?, on: :create

  scope :paid, ->{ where(status: STATUS_PAID) }
  scope :accepted, ->{ where(status: STATUS_ACCEPTED) } #implications for mulit participants vs. single participant
  scope :paid_or_accepted, ->{ where(status: [STATUS_PAID, STATUS_ACCEPTED]) }

  def full_name
    [first_name, last_name].join(" ")
  end

  def guest_name
    full_name
  end

  def validate_date_falls_on_bookable_asset_schedule
  end

  def bookable_asset_in_bookable_state?
    unless self.bookable_asset.bookable?
      errors.add(:base, "Sorry, this bookable_asset cannot be booked right now. It's possible the instructor just filled up availability.")
    end
  end

  def paid_actions
    PrepareAutoCancellationJob.perform_in(48.hours, self.id)

    BookableAssetMailer.delay.new_application_email_to_provider(self)
    BookableAssetMailer.delay.application_confirmation_email_to_customer(self)
  end

  def rejection_actions
    self.order.capture_rejected = true
    self.order.save

    if self.bookable_asset.no_more_applications?
      self.bookable_asset.update_column(:status, BookableAsset::STATUS_PUBLISHED)
    end

    AdminMailer.delay.alert_order_capture_rejected(order)
    BookableAssetMailer.delay.cancellation_and_auth_void_notice_to_customer(self)
    BookableAssetMailer.delay.rejection_or_expiration_notice_to_provider(self)
  end

  def expiration_actions
    self.order.capture_rejected = true
    self.order.save

    if self.bookable_asset.no_more_applications?
      self.bookable_asset.update_column(:status, BookableAsset::STATUS_PUBLISHED)
    end

    AdminMailer.delay.application_expired_release_the_auth(self)
    BookableAssetMailer.delay.cancellation_and_auth_void_notice_to_customer(self)
    BookableAssetMailer.delay.rejection_or_expiration_notice_to_provider(self)
  end

  def accept_actions
    self.order.captured = true
    self.order.save

    self.bookable_asset.confirm!(self)

    AdminMailer.delay.alert_order_needs_to_be_captured(order)
    BookableAssetMailer.delay.confirmed_message_to_provider(self)
    BookableAssetMailer.delay.confirmed_message_to_customer(self)
  end

  def paid!
    update_status(STATUS_PAID)
  end

  def provider_reject!
    update_status(STATUS_REJECTED)
  end

  def expire!
    update_status(STATUS_EXPIRED)
  end

  def accept!
    update_status(STATUS_ACCEPTED)
  end

  def new?
    self.status == STATUS_NEW
  end

  def accepted?
    self.status == STATUS_ACCEPTED
  end

  def expired?
    self.status == STATUS_EXPIRED
  end

  def rejected?
    self.status == STATUS_REJECTED
  end

  def paid?
    self.status == STATUS_PAID
  end

  def pending_reschedule?
    self.status == STATUS_PENDING_RESCHEDULE
  end

  private

  def update_status(status)
    self.update_attribute(:status, status)
  end

  def status_changed_to?(status)
    self.status_changed? && self.status == status
  end

end
