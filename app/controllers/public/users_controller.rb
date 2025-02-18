class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images.page(params[:page])
  end

  def edit
  end

  def update
    if @user.update(user_params)
    flash[:notice] = "You have updated user successfully."
    redirect_to user_path
    else
    render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to new_user_registration_path, notice: 'ユーザー情報が正常に削除されました'
    else
      redirect_to user_path, alert: '削除に失敗しました'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

  def is_matching_login_user
    @user = User.find_by_id(params[:id])
    if @user != current_user
      redirect_to post_images_path
    end
  end
end
