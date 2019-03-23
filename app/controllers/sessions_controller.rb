class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:create]
  before_action :already_sign_in?, only: [:new]

  def new; end

  def create
    respond_to do |format|
      if @user.authenticate(session_params[:password])
        sign_in(@user)
        format.html { redirect_to root_path, notice: 'ログインに成功しました。' }
      else
        flash.now[:alert] = "ログインできませんでした。ユーザー名またはメールアドレスを確認してください。"
        format.html { render :new }
      end
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private
    def set_user
      @user = User.find_by!(name: session_params[:name])
    rescue
      flash[:alert] = "ログインできませんでした。ユーザー名またはメールアドレスを確認してください。"
      render action: 'new'
    end

    def session_params
      params.require(:session).permit(:name, :password)
    end
end
