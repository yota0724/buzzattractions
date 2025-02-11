class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post_image

  validates :body, presence: true
end
