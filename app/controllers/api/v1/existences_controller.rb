require 'securerandom'

class Api::V1::ExistencesController < ApplicationController
  skip_before_action :require_sign_in!

  protect_from_forgery :except => [:post]

  def post
    now_time = Time.now()
    name = params[:name].downcase
    password = params[:password]
    status = params[:status]
    user = User.find_by(name: name)

    unless white_list(request.remote_ip)
      render json: {status: 400, message: "許可されていない端末からのアクセスのため失敗しました。"} and return
    end

    if user.blank?
      user = User.new(
        name: name,
        password: password,
        pixela_token: SecureRandom.hex(32)
      )

      # CreateUser
      user_uri = URI.parse("https://pixe.la/v1/users/")
      user_http = Net::HTTP.new(user_uri.host, user_uri.port)

      user_http.use_ssl = true
      user_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      user_post_params = {
        token: user.pixela_token,
        username: user.name,
        agreeTermsOfService: "yes",
        notMinor: "yes"
      }

      user_req = Net::HTTP::Post.new(user_uri)
      user_req.body = user_post_params.to_json

      user_res = user_http.request(user_req)
      user_result = JSON.parse(user_res.body)

      # CreateGraph
      graph_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs")
      graph_http = Net::HTTP.new(graph_uri.host, graph_uri.port)

      graph_http.use_ssl = true
      graph_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      graph_post_params = {
        id: "access-graph",
        name: "#{user.name}-graph",
        unit: "hour",
        type: "int",
        color: "shibafu"
      }

      graph_req = Net::HTTP::Post.new(graph_uri)
      graph_req.body = graph_post_params.to_json
      graph_req["X-USER-TOKEN"] = user.pixela_token

      graph_res = graph_http.request(graph_req)
      graph_result = JSON.parse(graph_res.body)

      if user_result["isSuccess"] && graph_result["isSuccess"]
        user.save
        render json: {status: 200, message: "User create successfully!"}
      else
        render json: {user_result: user_result, graph_result: graph_result} and return
      end
    end

    if user.status == status
      render json: {status: 400, message: "既に出席もしくは退席中のため失敗しました。"} and return
    end

    if status
      # Slack出席通知処理
      notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
      notifier.ping(
        "[#{Rails.env}] #{user.name}さんが出席しました。"
      )

      existence = user.existences.order(:created_at).create(user_id: user.id)
      user.update!(status: true)
      existence.update!(enter_time: update_time(nil, now_time))
    else
      existence = user.existences.order(:created_at).last
      existences = Existence.where(user_id: user.id)
      total_time = total_time(existences)

      #delete_pixel
      delete_pixel(user, now_time.strftime("%Y%m%d"))

      if create_pixel(user, now_time, total_time) # CreatePixel
        # Slack退席通知処理
        notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
        notifier.ping(
          "[#{Rails.env}] #{user.name}さんが退席しました。"
        )
        user.update!(status: false, total_time: total_time)
        existence.update!(exit_time: update_time(nil, now_time))
        render json: {status: 200, message: "Pixel create successfully!"}
      else
        render json: {status: 400, message: "Pixel create faild..."}
      end
    end
  end

  private
    def white_list(ip)
      if Rails.env.production
        return true if ENV["LAB_IP_ADDRESS"] == ip
        false
      else
        true
      end
    end
end
