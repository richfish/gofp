class ConversationsController < ApplicationController

  def index
  end

  def show
    #@conversation = Conversation.includes(:comments).find_by_euid(params[:euid])
    @conversation = Conversation.includes(:comments).find_by_id(params[:id])
  end

  def create
  #  @bootcamp = Bootcamp.bookable.find(params[:bootcamp_id]) #TODO technically open to hacky stuff, but in context of app doesn't matter.
    #@conversation = @bootcamp.conversations.build(set_params)
    @conversation = Conversation.new(set_params)
    @conversation.converser_id = 1
    @conversation.conversant_id = 2

    # if conversation_exists_for_this_bootcamp?(@bootcamp)
    #   return redirect_to(conversation_path(@conversation, euid: @conversation.euid, guest: rand(12125125...9351335135)))
    # end

    if @conversation.save
      flash[:notice] = "Inquiry sent. You will likley receive a response email soon."
      redirect_to conversation_path(@conversation)
      #redirect_to conversation_path(@conversation, euid: @conversation.euid, guest: rand(12125125...9351335135))
    else
      gon.push(conversation_errors: true)
      render "bootcamps/show"
    end
  end

  def update
    #set_guest_params
    #@conversation = Conversation.find_by_euid(params[:euid])
    @conversation = Conversation.find_by_id(params[:id])
    if @conversation.update_attributes(set_params) #might work with bested attrs automatically
      flash[:notice] = "Responded succesfully."
      if false#get_guest_params
        redirect_to conversation_path(@conversation, euid: @conversation.euid, guest: rand(12125125...9351335135))
      else
        redirect_to conversation_path(@conversation)
      end
    else
      @guest_error = rand(12125125...9351335135) if get_guest_params.present?
      render :show
    end
  end

  private

  def conversation_exists_for_this_bootcamp?(bootcamp)
    bootcamp.conversations.find_by_guest_email(params[:conversation][:guest_email]).present?
  end

  def get_guest_params
    params[:conversation][:comments_attributes]["0"][:guest]
  end

  def set_guest_params(val=nil)
    params[:conversation][:comments_attributes]["0"][:guest] = val || get_guest_params.present?
  end

  def set_params
    params.require(:conversation).permit(:first_name, :last_name, :guest_email, :potential_date, :comments_attributes => [:message, :guest])
  end
end
