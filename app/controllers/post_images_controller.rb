class PostImagesController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    if @post_image.save
      flash[:notice] = "You have created post successfully."
      redirect_to post_images_path
    else
      flash.now[:alert] = "failed"
      render :new
    end
  end

  def index
    @post_images = PostImage.page(params[:page])
  end

  def show
    @post_image = PostImage.find(params[:id])
  end

  def edit
    @post_image = PostImage.find(params[:id])
  end
  
  def update
    @post_image = PostImage.find(params[:id])
    if @post_image.update(post_image_params)
      flash[:notice] = "You have updated post successfully."
      redirect_to post_image_path(@post_image.id)
    else
      render :edit
    end
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end

  private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :body)
  end

  def is_matching_login_user
    post_image = PostImage.find(params[:id])
    unless post_image.user == current_user
      redirect_to post_images_path
    end
  end    
end
