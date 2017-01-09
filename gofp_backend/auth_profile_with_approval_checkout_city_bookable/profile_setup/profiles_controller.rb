class ProfilesController < ApplicationController

  before_filter ->{ @profile = current_user.profile }, except: [:new, :image_asset]

  def new
    @profile = current_user.profile || current_user.create_profile #No CREATE action; b/c of #image_asset
    @creating = true
  end

  def image_asset
    #TODO image module?
    #USING image_changed MERELY AS WAY TO TRIGGER RE_APPROVAL EMAIL WHEN PUBLISHED USERS CHANGE IMAGE; DOESN'T AFFECT USERS
    profile = current_user.profile
    profile.assign_attributes(set_params)
    profile.save(context: :image)
    image = current_user.profile.reload.avatar.url(:medium)
    respond_to do |format|
      format.js { render text: image, status: :ok }
    end
  end

  def edit
  end

  def update
    @profile.assign_attributes(set_params)
    #@profile.rate_cents = (params[:profile][:rate_cents].to_f * 100).to_i
    #if ProfilePublishManager.new(@profile).subsequent_updates
    if @profile.save
      flash[:notice] = "Profile Updated"
      redirect_to user_path(current_user)
    else
      params[:profile][:creating] ? render(:new) : render(:edit)
    end
  end

  def show
    redirect_to user_path(current_user)
  end

  # def publish
  #   ProfilePublishManager.new(@profile).first_publish
  #   flash[:notice] = "Success - You're Pending Published. Check back soon, and we'll email you when you're live."
  #   redirect_to user_path(current_user)
  # end
  #
  # def take_off_hiatus
  #   ProfilePublishManager.new(@profile).return_from_hiatus!
  #   flash[:notice] = "Success - you are back, public, and visible in searches."
  #   redirect_to user_path(current_user)
  # end

  private

  def set_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)
  end

  def set_image
    params.require(:profile).permit(:avatar)
  end

end

#error messages: do you need to explicitly set errors using AR goodness?
