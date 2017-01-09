class Profile < ActiveRecord::Base
  #for form boilerplate
   attr_accessor :customer_gender, :target_gender, :datingbio, :service_description, :about_customer, :facebook_link, :rate_cents,
          :beers, :instructions, :customer_contact_email, :phone

  STATUS_NEW = :new.to_s
  # STATUS_UNPUBLISHED_PENDING_APPROVAL = :published_pending.to_s
  # STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED = :fix_issue_window_unpublished.to_s
  # STATUS_PUBLISHED = :published.to_s
  # STATUS_BLOCKED = :blocked.to_S
  #etc...

  STATUSES = [STATUS_NEW] #add others

  #after_save ->{ raise Exceptions::CannotEdit if self.cannot_edit_state? }, on: :update

  belongs_to :user

  has_attached_file :avatar,
                     :styles => { :medium => "300x350!", :thumb => "100x118>", :profile => "400x400>", :tiny => "18x20!" },
                     :default_url => "missing.png",
                     :s3_protocol => (Rails.env.development? || Rails.env.test?) ? :http : :https

  #CUSTOMIZE
  # with_options on: :update do |profile|
  #   profile.validates_presence_of :first_name, message: '- You must provide some sort of name (preferably your own)'
  #   profile.validates_presence_of :about_customer, message: "- You must provide a brief description of your prefered customer. This is for your benefit."
  #   profile.validates_presence_of :service_description, message: " - You must provide a description of your outing."
  #   profile.validates_presence_of :instructions, message: "- You should leave at least a little instruction relevant to your outing. Customers will feel better."
  #   profile.validates_presence_of :rate_cents, "- Set your going rate."
  #   profile.validate :acceptable_rate
  # end

  validates_attachment :avatar, :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, on: :image
  validates_inclusion_of :status, in: STATUSES

  def publicly_searchable?
    #CUSTOMIZE
    false
  end

  def published?
    #CUSTOMIZE
    false
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  # def acceptable_rate
  #   unless beers
  #     if rate_cents.to_f < 5.0 #to_f returns 0 if non numerical characters
  #       errors.add(:base, "Your rate needs to be at least $5/hour, or check beers if you want beer instead.")
  #     end
  #   end
  # end

  # def cannot_edit_state?
  #   self.unpublished_pending_approval? && !first_time_publishing? && !act_of_fixing_issue?
  # end
  #
  # private
  #
  #  def first_time_publishing?
  #    self.status_changed? && self.status_was == STATUS_UNPUBLISHED && self.unpublished_pending_approval?
  #  end
  #
  #  def act_of_approving?
  #    self.status_changed? && self.status_was == STATUS_UNPUBLISHED_PENDING_APPROVAL && self.published?
  #  end
  #
  #  def act_of_fixing_issue?
  #    self.status_changed? && self.status_was == STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
  #  end

end



