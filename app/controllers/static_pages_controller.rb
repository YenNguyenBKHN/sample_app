class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = Micropost.by_user(current_user.id)
      .page(params[:page]).per Settings.page_size
  end

  def help; end

  def about; end

  def contact; end
end
