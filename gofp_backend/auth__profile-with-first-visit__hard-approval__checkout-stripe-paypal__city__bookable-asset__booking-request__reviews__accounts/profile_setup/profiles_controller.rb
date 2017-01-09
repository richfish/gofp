class ProfilesController < ApplicationController

  before_filter ->{ @profile = current_user.profile }


  def new
  end

  def profile_image
    #NOTE, image is now being handle via user object.
    avatar = current_user.avatar || current_user.build_avatar
    avatar.image = params[:asset][:image]
    if avatar.save
      image = current_user.avatar.reload.image.url(:small)
      respond_to do |format|
        format.js { render text: image, status: :ok}
      end
    else
      puts 'error saving avatar'
    end
  end

  def edit
  end

  def create
    @profile = current_user.build_profile(set_params)
    if @profile.save
      flash[:notice] = "Success, profile created"
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def update
    @profile.assign_attributes(set_params)
    if @profile.save
      flash[:notice] = "Profile Updated"
      redirect_to user_path(current_user)
    else
      render(:edit)
    end
  end

  def show
    redirect_to user_path(current_user)
  end

  private

  def set_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)
  end

  def set_image
    params.require(:profile).permit(:avatar)
  end

end

#error messages: do you need to explicitly set errors using AR goodness?
