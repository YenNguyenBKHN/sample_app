class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_reset_pass"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("can't_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "pass_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    return if @user = User.find_by(email:
      params[:password_reset][:email].downcase)

    flash[:danger] = t "email_not_found"
    render :new
  end

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t "not_found"
    render :new
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset_pass_expired"
    redirect_to new_password_reset_url
  end
end
