require 'securerandom'

class Api::V1::ExistencesController < ApplicationController
  skip_before_action :require_sign_in!
  before_action :white_list_ip?

  protect_from_forgery :except => [:post]

  def post
    begin
      now_time = Time.now()
      status = params[:status] == "1" ? true : false
      user = User.find_by(address: params[:addr])

      if user.present?
        if user.status == status
          render json: {status: 400, message: "既に出席もしくは退席中のため失敗しました。"} and return
        end

        username = user.nickname.present? ? user.nickname : user.name
        if status
          # Slack出席通知処理
          slack_notification("#{username}さんが出席しました。")

          existence = user.existences.order(:created_at).create(user_id: user.id)
          user.update!(status: true)
          existence.update!(enter_time: update_time(nil, now_time))
          render json: {status: 200, message: "#{username}さんが出席しました。"}
        else
          existence = user.existences.order(:created_at).last
          existence.update!(exit_time: update_time(nil, now_time))

          existences = Existence.where(
            user_id: user.id,
            enter_time: now_time.in_time_zone.all_day
          )
          total_time = total_time(Existence.where(user_id: user.id))

          #delete_pixel
          delete_pixel(user, now_time.strftime("%Y%m%d"))

          if create_pixel(user, now_time, total_time(existences)) # CreatePixel
            # Slack退席通知処理
            slack_notification("#{username}さんが退席しました。")

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
