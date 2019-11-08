class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_size}
  validates :image, content_type: {in: Settings.content_type,
                                   message: I18n.t("valid_image")},
    size: {less_than: Settings.image_size.megabytes,
           message: I18n.t("image_size")}
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :by_user_id, ->(id){where user_id: id}
  scope :by_user, (lambda do |id|
    where(user_id: Relationship.following_ids(id))
      .or(Micropost.where(user_id: id))
  end)

  def display_image
    image.variant resize_to_limit: Settings.resize_to_limit
  end
end
