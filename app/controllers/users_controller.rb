class UsersController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :already_sign_in?, only: [:new, :create]
  before_action :white_list_ip?, only: [:new, :create]

  def index
    @users = User.where(status: true)
  end

  def show; end

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

    # CreateUser
    user_uri = URI.parse("https://pixe.la/v1/users/")
    user_http = Net::HTTP.new(user_uri.host, user_uri.port)

    user_http.use_ssl = true
    user_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    user_post_params = {
      token: @user.pixela_token,
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
    graph_req["X-USER-TOKEN"] = @user.pixela_token

    graph_res = graph_http.request(graph_req)
    graph_result = JSON.parse(graph_res.body)

    puts user_result["isSuccess"]
    puts graph_result["isSuccess"]

    respond_to do |format|
      if @user.save && user_result["isSuccess"] && graph_result["isSuccess"]
        notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
        notifier.ping(
          "[#{Rails.env}] #{username}さんが出席しました。"
        )

        existence = @user.existences.create(user_id: @user.id, enter_time: update_time(nil, now_time))

        sign_in(@user)
        format.html { redirect_to @user, notice: 'ユーザー登録が完了しました。' }
      else
        flash[:alert] = "ユーザ登録ができませんでした。再度やり直してください"
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

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :nickname, :picture, :password, :password_confirmation, :address).merge(status: true, pixela_token: SecureRandom.hex(32))
    end
end
