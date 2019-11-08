module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def find_following id
    return if current_user.active_relationships.find_by followed_id: id

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def make_following
    current_user.active_relationships.build
  end
end
