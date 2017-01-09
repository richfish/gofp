class Comment < ActiveRecord::Base

  #Rule: Provider must be signed in to comment (only way to know for sure whether guest or not comment)

  #before_create { self.guest = true if self.conversation.comments.blank? }
  #before_create :set_sequence_num
  after_create :send_email_if_needed

  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count

  validates_presence_of :message, message: "- you must write something."

  def set_sequence_num
    if self.commentable.is_a?(Conversation)
      latest_num = self.conversation.comments.maximum(:sequence_num) || 0
      self.sequence_num = latest_num + 1
    end
  end

  def send_email_if_needed
    return true
    if self.commentable.is_a?(Conversation)
      if self.guest
        ConversationMailer.delay.message_conversant(self)
      else
        ConversationMailer.delay.message_conversert(self)
      end
    end
  end

  def conversation
    if self.commentable.is_a?(Conversation)
      self.commentable
    end
  end

  def author_name
    self.guest ? self.guest_name : self.commentable.bootcamp.user.full_name
  end

end
