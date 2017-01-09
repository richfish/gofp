class CommentDecorator < Draper::Decorator
  delegate_all

  include ActionView::Helpers

  def display_date
    h.local_time_for_user(self.conversation.bootcamp.user, self.created_at).strftime(Conversation::DATEFORMAT)
  end

  def author_with_image
   ret =  if self.guest
      self.conversation.first_name
    else
      self.conversation.bootcamp.user.profile.first_name.to_s + ' ' +
      h.profile_image_xxsmall(self.conversation.bootcamp.user.profile).to_s
    end
    ret.html_safe
  end

end
