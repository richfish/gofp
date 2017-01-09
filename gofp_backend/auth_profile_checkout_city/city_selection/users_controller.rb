class UsersController < ApplicationController

  before_filter :push_cities

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def index
  end

  def search_providers
  end

  def update
    @user                = current_user
    email                = params[:user][:email]
    paypal_email         = params[:user][:paypal_email]
    password             = params[:user][:password]
    old_password         = params[:user][:old_password]
    new_password         = params[:user][:new_password]
    new_password_confirm = params[:user][:new_password_confirmation]

    if email && password
      if @user.valid_password?(password)
        if @user.update_attributes(set_allowable_city.merge!(params.require(:user).permit(:email)))
          handle_success
        else
          render :edit
        end
      else
        flash[:error] = "Invalid Password"
        render :edit
      end
    elsif paypal_email && password
      if @user.valid_password?(password)
        unless !!paypal_email[/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i]
          flash[:error] = "Invalid paypal email"
          render :edit
          return
        end
        if @user.update_attributes(set_allowable_city.merge!(params.require(:user).permit(:paypal_email)))
          handle_success
        else
          render :edit
        end
      else
        flash[:error] = "Invalid Password"
        render :edit
      end
    elsif new_password && old_password
      if @user.valid_password?(old_password) && (new_password == new_password_confirm)
        @user.password = new_password
        ret = @user.update_attributes(set_allowable_city)
        if @user.save && ret
          handle_success
        else
          render :edit
        end
      else
        flash[:error] = "Incorrect Password or Passwords don't Match"
        render :edit
      end
    elsif @user.update_attributes(set_allowable_city)
      handle_success
    else
      render :edit
    end
  end


  private

  def set_allowable_city
    permitted = params.require(:user).permit(:city)
    permitted.merge!({city: CityConformityPolicy.get_allowable_city(permitted[:city])})
  end

  def handle_success
    flash[:notice] = "Account Updated"
    sign_in @user, :bypass => true
    redirect_to user_path(@user)
  end

end
