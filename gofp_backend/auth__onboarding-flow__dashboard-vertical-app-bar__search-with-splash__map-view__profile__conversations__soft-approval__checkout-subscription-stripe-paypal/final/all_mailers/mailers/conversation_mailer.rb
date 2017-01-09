class ConversationMailer < ApplicationMailer
  def message_converser(message)
    @message = message
    @conversation = message.conversation
    email = @conversation.guest_email
    mail(to: email, subject: "You have a response from #{@conversation.bootcamp.user.profile.first_name}")
  end

  def message_conversant(message)
    @message = message
    @conversation = message.conversation
    email = @conversation.bootcamp.user.email
    mail(to: email, subject: "Message to Provider")
  end

end
