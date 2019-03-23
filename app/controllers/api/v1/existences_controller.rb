require 'securerandom'

class Api::V1::ExistencesController < ApplicationController
  skip_before_action :require_sign_in!
  before_action :white_list_ip?

  protect_from_forgery :except => [:post]

  def post
    begin
      now_time = Time.now()
      status = params[:status]
      user = User.find_by(address: params[:addr])

      if user.present?
        if user.status == status
          render json: {status: 400, message: "既に出席もしくは退席中のため失敗しました。"} and return
        end

        username = user.nickname.present? ? user.nickname : user.name
        if status
          # Slack出席通知処理
          notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
          notifier.ping(
            "[#{Rails.env}] #{username}さんが出席しました。"
          )

          existence = user.existences.order(:created_at).create(user_id: user.id)
          user.update!(status: true)
          existence.update!(enter_time: update_time(nil, now_time))
        else
          existence = user.existences.order(:created_at).last
          existence.update!(exit_time: update_time(nil, now_time))

          existences = Existence.where(user_id: user.id)
          total_time = total_time(existences)

          #delete_pixel
          delete_pixel(user, now_time.strftime("%Y%m%d"))

          if create_pixel(user, now_time, total_time) # CreatePixel
            # Slack退席通知処理
            notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
            notifier.ping(
              "[#{Rails.env}] #{username}さんが退席しました。"
            )
            user.update!(status: false, total_time: total_time)
            render json: {status: 200, message: "Pixel create successfully!"}
          else
            render json: {status: 400, message: "Pixel create faild..."}
          end
        end
      else
        render json: {status: 400, message: "ユーザー情報を取得できませんでした。"}
      end
    rescue => e
      render json: {status: 400, message: {class: e.class, error: e.message}}
    end
  end
end
