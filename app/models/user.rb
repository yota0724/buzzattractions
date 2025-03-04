class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  validates :name, presence:  true

  has_many :post_images, dependent: :destroy

  has_one_attached :profile_image

  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy

   # フォローしている関連付け
   has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    
   # フォローされている関連付け
   has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
   
   # フォローしているユーザーを取得
   has_many :followings, through: :active_relationships, source: :followed
   
   # フォロワーを取得
   has_many :followers, through: :passive_relationships, source: :follower

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  
    # 指定したユーザーをフォローする
    def follow(user)
      active_relationships.create(followed_id: user.id)
    end
    
    # 指定したユーザーのフォローを解除する
    def unfollow(user)
      active_relationships.find_by(followed_id: user.id).destroy
    end
    
    # 指定したユーザーをフォローしているかどうかを判定
    def following?(user)
      followings.include?(user)
    end

end
