class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.page_size
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.page_size
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "update_falsed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success_delete"
    else
      flash[:danger] = t "false_delete"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def find_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
