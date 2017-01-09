class ConversationMailer < ApplicationMailer
  def message_guest(message)
    @message = message
    @conversation = message.conversation
    email = @conversation.guest_email
    mail(to: email, subject: "You have a response from #{@conversation.bookable_asset.user.profile.first_name}")
  end

  def message_provider(message)
    @message = message
    @conversation = message.conversation
    email = @conversation.bookable_asset.user.email
    mail(to: email, subject: "Message to Provider")
  end

end