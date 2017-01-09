class Conversation < ActiveRecord::Base
  DATE_TIME_FORMAT = "%B %d, %Y %I:%M %P"
  DATEFORMAT = "%B %d, %I:%M%P"

  # belongs_to :bootcamp, class_name: "Program", foreign_key: "program_id"
  # belongs_to :power_session, class_name: "Program", foreign_key: "program_id"
  has_many :comments, ->{ order 'id desc' }, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true

  validate :permitted_conversation
  #validates_presence_of :first_name, :last_name, :guest_email, :potential_date

  scope :for_user, ->(user){ where("converser_id = :user_id OR conversant_id = :user_id", user_id: user.id) }

  # def comments_ordered
  #   comments.where(guest: true).order("sequence_num DESC")
  # end
  #
  # def provider_comments_ordered
  #   comments.where.not(guest: true).order("sequence_num DESC")
  # end

  # def guest_name
  #   [first_name, last_name].join(' ')
  # end

  def permitted_conversation
    true
    # unless self.bootcamp.bookable?
    #   errors.add(:base, "This conversation is frozen. The bootcamp is no longer bookable.")
    # end
  end

  def latest_message
    comments.first
  end

  def first_message
    comments.last
  end

end
