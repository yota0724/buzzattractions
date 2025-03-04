class Public::HomesController < ApplicationController
  def top
    @post_images = PostImage.order(id: :desc).limit(5)
  end

  def about
  end
end
