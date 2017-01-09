class Profile < ActiveRecord::Base
  
  STATUS_NEW = :new.to_s
  STATUS_PENDING_APPROVAL = :pending_approval.to_s
  STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED = :fix_issue_window_unpublished.to_s
  STATUS_PUBLISHED = :published.to_s
  STATUS_REJECTED = :rejected.to_s
  STATUS_BLOCKED = :blocked.to_s

  STATUSES = [STATUS_NEW, STATUS_PENDING_APPROVAL, STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED, STATUS_PUBLISHED, STATUS_REJECTED, STATUS_BLOCKED]

  after_save ->{ raise Exceptions::CannotEdit if self.cannot_edit_state? }, on: :update

  belongs_to :user
  has_many :issues, as: :issueable, dependent: :destroy

  #CUSTOMIZE
  # validates_presence_of :first_name, message: '- You must provide some sort of name (preferably your own)'
  # validates_presence_of :last_name, message: '- You must provide your last name too'
  # validates_presence_of :qualification_description, message: " - You must give a description of your qualifications"
  # validates_presence_of :core_competencies, message: "- You must describe your core technology stack and/or other competencies"
  # validates_presence_of :teaching_style, mesage: "- You must leave a brief description of your teaching philosophy"
  # validates_presence_of :linkedin_link, message: "- You must provide a link to your LinkedIn Profile"
  # validates_length_of :qualification_description, :core_competencies, :teaching_style, minimum: 20
  # validates_inclusion_of :status, in: STATUSES
  # validates_format_of :linkedin_link, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  # validates_format_of :github_link, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix, if: ->{ self.github_link.present? }
  # validates_format_of :portfolio_link, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix, if: ->{ self.portfolio_link.present? }
  # validates_format_of :linkedin_link, with: /linkedin.com/, message: " - you're not using the Linkedin.com domain..."
  # validates_format_of :github_link, with: /github.com/, message: " - you're not using the Github.com domain....", if: ->{ self.github_link.present? }
  # validate :years_experience
  # validate :avatar_presence

  validates_inclusion_of :status, in: STATUSES

  def avatar_presence
    if self.user.avatar.blank?
      errors.add(:base, "Please upload an avatar image for your profile.")
    end
  end

  def editable?
    !unpublished_pending_approval?
  end

  def publicly_searchable?
    published?
  end

  def published?
    self.status == STATUS_PUBLISHED
  end

  def new?
    unpublished?
  end

  def unpublished?
     self.status == STATUS_NEW
   end

   def unpublished_pending_approval?
     self.status == STATUS_PENDING_APPROVAL
   end

   def fixing_issue_unpublished?
     self.status == STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
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

  def cannot_edit_state?
    self.unpublished_pending_approval? && !first_time_publishing? && !act_of_fixing_issue?
  end

  # def years_experience
  #   years = self.years_experience.to_f
  #   unless years >= 3.to_f
  #     errors.add(:base, "You must select years of professional experience")
  #   end
  # end

  private

   def first_time_publishing?
     self.status_changed? && self.status_was == STATUS_NEW && self.unpublished_pending_approval?
   end

   def act_of_approving?
     self.status_changed? && self.status_was == STATUS_PENDING_APPROVAL && self.published?
   end

   def act_of_fixing_issue?
     self.status_changed? && self.status_was == STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
   end

end
