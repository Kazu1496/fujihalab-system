class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where('status = ?', 1)
  end

  def show; end

  def edit; end

  def ranking
    @users = User.all.order(total_time: :desc)
  end

  def member
    @users = User.all
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'ユーザー情報を更新しました。' }
      else
        flash[:alert] = "ユーザー情報の更新ができませんでした。再度やり直してください"
        format.html { render :edit }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :nickname, :picture, :password, :password_confirmation)
    end
end
