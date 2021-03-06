class UsersController < ApplicationController

  before_filter :ensure_confirmed, only: :show
  before_filter :authenticate_user!

  def ensure_confirmed
    unless user_signed_in?
      flash[:warn] = "It looks like you need to confirm your account - check your email."
      return redirect_to login_path
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def index
  end

  def update
    @user                = current_user
    email                = params[:user][:email]
    password             = params[:user][:password]
    old_password         = params[:user][:old_password]
    new_password         = params[:user][:new_password]
    new_password_confirm = params[:user][:new_password_confirmation]

    if email && password
      old_email = @user.email
      if @user.valid_password?(password)
        if @user.update_attributes(params.require(:user).permit(:email))
          Borrower.where(email: old_email).update_all(email: email)
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
        if @user.save
          handle_success
        else
          render :edit
        end
      else
        flash[:error] = "Incorrect Password or Passwords don't Match"
        render :edit
      end
    else
      render :edit
    end
  end


  private

  def handle_success
    flash[:notice] = "Account Updated"
    sign_in @user, :bypass => true
    redirect_to user_path(@user)
  end

end
