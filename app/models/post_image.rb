class PostImage < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  #has_many :favorites, dependent: :destroy
  #has_many :post_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :image, presence: true

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :commented_users, through: :comments, source: :user

scope :latest, -> {order(created_at: :desc)}
scope :old, -> {order(created_at: :asc)}
scope :most_favorited, -> { includes(:favorited_users)
  .sort_by { |x| x.favorited_users.includes(:favorites).size }.reverse }
scope :most_commented, -> { includes(:commented_users)
  .sort_by { |x| x.commented_users.includes(:comments).size }.reverse }

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

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.liked_posts(user, page, per_page) # 1. モデル内での操作を開始
    includes(:favorites) # 2. post_favorites テーブルを結合
      .where(favorites: { user_id: user.id }) # 3. ユーザーがいいねしたレコードを絞り込み
      .order(created_at: :desc) # 4. 投稿を作成日時の降順でソート
      .page(page) # 5. ページネーションのため、指定ページに表示するデータを選択
      .per(per_page) # 6. ページごとのデータ数を指定
  end
end
