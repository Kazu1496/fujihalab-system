class UsersController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :already_sign_in?, only: [:new, :create]

  def index
    @users = User.where(status: true)
  end

  def show
    @existences = @user.existences.order_by_enter_at.paginate(page: params[:page], per_page: 5)
  end

  def edit; end

  def ranking
    @users = User.all.order(total_time: :desc)
  end

  def member
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    now_time = Time.now()
    username = @user.nickname.present? ? @user.nickname : @user.name

    begin
      # CreateUser
      user_uri = URI.parse("https://pixe.la/v1/users/")
      user_http = Net::HTTP.new(user_uri.host, user_uri.port)

      user_http.use_ssl = true
      user_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      user_post_params = {
        token: 'fujihalabtoken',
        username: @user.name,
        agreeTermsOfService: "yes",
        notMinor: "yes"
      }

      user_req = Net::HTTP::Post.new(user_uri)
      user_req.body = user_post_params.to_json

      user_res = user_http.request(user_req)
      user_result = JSON.parse(user_res.body)

      # CreateGraph
      graph_uri = URI.parse("https://pixe.la/v1/users/#{@user.name}/graphs")
      graph_http = Net::HTTP.new(graph_uri.host, graph_uri.port)

      graph_http.use_ssl = true
      graph_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      graph_post_params = {
        id: "access-graph",
        name: "#{@user.name}-graph",
        unit: "hour",
        type: "int",
        color: "shibafu"
      }

      graph_req = Net::HTTP::Post.new(graph_uri)
      graph_req.body = graph_post_params.to_json
      graph_req["X-USER-TOKEN"] = 'fujihalabtoken'

      graph_res = graph_http.request(graph_req)
      graph_result = JSON.parse(graph_res.body)
    rescue
      flash[:alert] = "ユーザーIDには半角英数文字またはハイフン（-）のみ使用できます。"
      render :new and return
    end

    respond_to do |format|
      if user_result["isSuccess"] && graph_result["isSuccess"]
        if @user.save
          # Slack退席通知処理
          slack_notification("🎉#{username}さんがユーザー登録しました🎉")

          @user.existences.create(enter_time: update_time(nil, now_time))

          sign_in(@user)
          format.html { redirect_to @user, notice: 'ユーザー登録が完了しました。' }
        else
          # DeleteUser
          delete_user_uri = URI.parse("https://pixe.la/v1/users/#{@user.name}")
          delete_user_http = Net::HTTP.new(delete_user_uri.host, delete_user_uri.port)

          delete_user_http.use_ssl = true
          delete_user_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          delete_user_req = Net::HTTP::Delete.new(delete_user_uri)
          delete_user_req["X-USER-TOKEN"] = 'fujihalabtoken'

          delete_user_res = delete_user_http.request(delete_user_req)
          delete_user_result = JSON.parse(user_res.body)

          logger.debug(delete_user_result)

          flash[:alert] = "ユーザ登録ができませんでした。再度やり直してください"
          format.html { render :new }
        end
      else
        flash[:alert] = "既にPixe.laに登録済みのユーザー名のため登録に失敗しました。"
        format.html { render :new }
      end
    end
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

  def leave
    now_time = Time.now()
    user = User.find_by(id: @current_user.id)
    existences = Existence.where(user_id: user.id)
    existence = existences.order(:created_at).last
    existence.update!(exit_time: update_time(nil, now_time))
    total_time = total_time(existences)

    #delete_pixel
    delete_pixel(user, now_time.strftime("%Y%m%d"))

    username = user.nickname.present? ? user.nickname : user.name
    respond_to do |format|
      if create_pixel(user, now_time, total_time) && user.status != false # CreatePixel
        # Slack退席通知処理
        slack_notification("#{username}さんが退席しました。")
        user.update!(status: false, total_time: total_time)

        format.html { redirect_to root_path, notice: '退席しました。' }
      else
        flash[:alert] = "退席することができませんでした。再度やり直してください"
        format.html { redirect_to :index }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :nickname, :picture, :password, :password_confirmation, :address)
    end
end
