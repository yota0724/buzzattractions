class PostImage < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  #has_many :favorites, dependent: :destroy
  #has_many :post_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :image, presence: true

  has_many :comments, dependent: :destroy

# 検索方法分岐
def self.looks(search, word)
  if search == "perfect_match"
    @post_image = PostImage.where("title LIKE?","#{word}")
  elsif search == "forward_match"
    @post_image = PostImage.where("title LIKE?","#{word}%")
  elsif search == "backward_match"
    @post_image = PostImage.where("title LIKE?","%#{word}")
  elsif search == "partial_match"
    @post_image = PostImage.where("title LIKE?","%#{word}%")
  else
    @post_image = PostImage.all
  end
end

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(gravity: :center, resize:"#{width}x#{height}^", crop:"#{width}x#{height}+0+0").processed
  end
end
