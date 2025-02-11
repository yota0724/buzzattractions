class CommentsController < ApplicationController
  def create
    @post_image = PostImage.find(params[:post_image_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_image_id = @post_image.id
    if @comment.save
      flash[:notice] = "success"
      redirect_to post_image_path(@post_image)
    else
      @comments = @post_image.comments
      flash[:alert] = "failed"
      redirect_to post_image_path(@post_image)
    end
  end
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to post_image_path(comment.post_image)
  end


  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end
