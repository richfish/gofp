class BookableAsset < ActiveRecord::Base
  STATUS_NEW = :new.to_s
  STATUS_PENDING_APPROVAL = :pending_approval.to_s
  STATUS_PUBLISHED = :published.to_s
  STATUS_UNCONFIRMED = :unconfirmed.to_s
  STATUS_CONFIRMED = :confirmed.to_s #current, underway Tuxedos
  STATUS_COMPLETE = :complete.to_s
  STATUS_CUSTOMER_CANCELLED = :customer_cancelled.to_s
  STATUS_PROVIDER_CANCELLED = :provider_cancelled.to_s
  STATUS_MIDWAY_STOP = :midway_stop.to_s

  DATEFORMAT = "%B %d, %Y"
  DATEFORMAT_WITH_DAY = "%A %B %d, %Y"
  TIMEFORMAT = "%I:%M %P"
  TIMEFORMAT_MILITARY = "%H:%M %P"
  TIMEFORMAT_NON_MILITARY = "%l:%M%P"
  HOUR_REGEXP = Regexp.new(/(\d+):.+/)
  MINUTE_REGEXP = Regexp.new(/\d+:(\d+)/)

  STATUSES = [STATUS_NEW, STATUS_PENDING_APPROVAL, STATUS_PUBLISHED, STATUS_UNCONFIRMED, STATUS_CONFIRMED, STATUS_COMPLETE, STATUS_CUSTOMER_CANCELLED, STATUS_PROVIDER_CANCELLED, STATUS_MIDWAY_STOP]

  after_save :prompt_review, if: ->{ status_changed_to? STATUS_COMPLETE }
  after_save :now_pending_operations, if: ->{ status_changed_to? STATUS_UNCONFIRMED }
  after_save :cancellation_by_provider, if: ->{ status_changed_to? STATUS_PROVIDER_CANCELLED }
  after_save :cancellation_by_customer, if: ->{ status_changed_to? STATUS_CUSTOMER_CANCELLED }
  after_save :successful_confirmation_to_provider, if: ->{ status_changed_to? STATUS_CONFIRMED }

  belongs_to :user
  has_many :booking_requests, dependent: :destroy

  validates_inclusion_of :status, in: STATUSES

  scope :for_provider, ->(user){ where('bookable_asset.user_id' => user) }
  scope :bookable, ->{ where(status: STATUS_PUBLISHED) }
  scope :current, ->{ where(status: [STATUS_UNCONFIRMED, STATUS_CONFIRMED]) }
  scope :bookable_and_current, ->{ where(status: [STATUS_PUBLISHED, STATUS_UNCONFIRMED, STATUS_CONFIRMED]) }
  scope :complete, ->{ where(status: STATUS_COMPLETE) }
  scope :needs_confirmation, -> { where(status: STATUS_UNCONFIRMED) }
  scope :cancelled, -> { where(status: [STATUS_CUSTOMER_CANCELLED, STATUS_PROVIDER_CANCELLED]) }
  scope :confirmed, -> { where(status: STATUS_CONFIRMED) }

  def double_validate_BookableAsset_time_is_ok
    # if BookableAssetTimeManager.new(self).BookableAsset_within_24_hours?
    #   raise Exceptions::TooSoon
    # end
    # if ScheduleConflictManager.BookableAsset_conflicts_with_existing_BookableAssets?(self)
    #   raise Exceptions::ForbiddenBookableAssetTime
    # end
  end

  def set_expiration_for_new
    ClearExpiredNewBookableAssetsJob.perform_in(61.minutes, self.id)
  end

  def confirmation_email_to_provider
    BookableAssetMailer.delay.bookable_asset_confirmation_for_provider(self)
  end

  def confirmation_email_to_cusomter
    BookableAssetMailer.delay.confirmation_to_customer(self)
  end

  def prepare_autocancellation
    hours_left = BookableAssetTimeManager.new(self).hours_until_cancellation
    PrepareAutoCancellationJob.perform_in(hours_left.hours, self.id)
  end

  def cancellation_by_customer
    BookableAssetMailer.delay.customer_cancellation_notice_to_provider(self)
    AdminMailer.delay.may_need_partial_refund_for_customer_cancelled(self)
  end

  def cancellation_by_provider
    BookableAssetMailer.delay.cancellation_and_refund_notice_to_customer(self)
    BookableAssetMailer.delay.cancellation_notice_by_provider_to_provider(self)
    AdminMailer.delay.need_to_refund_for_provider_cancelled(self)
  end

  def successful_confirmation_to_provider
    BookableAssetMailer.delay.successful_confirmation_to_provider(self)
  end

  def prepare_status_change_to_complete
    end_time = BookableAssetTimeManager.new(self).get_end_time
    PrepareCompleteStatusJob.perform_at(end_time, self.id)
  end

  def prompt_review
    PromptReviewJob.perform_in(24.hours, self.id)
  end

  def confirm!
    update_status(STATUS_CONFIRMED)
  end

  def pending!
    update_status(STATUS_PENDING)
  end

  def complete!
    update_status(STATUS_COMPLETE)
  end

  def provider_cancel!(reschedule_note=nil)
    #update_column(:reschedule_note, reschedule_note)
    update_status(STATUS_PROVIDER_CANCELLED)
  end

  def customer_cancel!
    update_status(STATUS_CUSTOMER_CANCELLED)
  end

  def searchable?
    self.status == STATUS_PUBLISHED
  end

  private

  def update_status(status)
    self.update_attribute(:status, status)
  end

  def now_pending_operations
    confirmation_email_to_provider
    confirmation_email_to_cusomter
    prepare_autocancellation
    prepare_status_change_to_complete
  end

  def status_changed_to?(status)
    self.status_changed? && self.status == status
  end


end
