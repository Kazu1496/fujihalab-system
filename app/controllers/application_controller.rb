require 'net/https'
require 'open-uri'

class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  protect_from_forgery with: :exception

  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    @current_user = nil
    cookies.delete(:user_remember_token)
  end

  def signed_in?
    @current_user.present?
  end

  def total_time(existences)
    total_time = 0
    if existences.present?
      existences.each do |existence|
        if existence.exit_time.present?
          sec = (existence.exit_time.to_time - existence.enter_time.to_time).to_i
          total_time += sec / 60
        end
      end
    end
    total_time
  end

  def update_time(current_time, updated_time)
    if current_time.present?
      date = current_time.strftime("%Y%m%d")
      datetime = updated_time.strftime("%H%M")
      updated_date = date + datetime
    else
      datetime = updated_time.strftime("%Y%m%d%H%M")
      updated_date = datetime
    end
    updated_date.to_time
  end

  def create_pixel(user, date, total_time)
    quantity = (total_time / 60) > 1 ? (total_time / 60) : 1

    pixel_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs/access-graph")
    pixel_http = Net::HTTP.new(pixel_uri.host, pixel_uri.port)

    pixel_http.use_ssl = true
    pixel_http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    pixel_post_params = {
      date: date.strftime("%Y%m%d"),
      quantity: quantity.to_s
    }

    pixel_req = Net::HTTP::Post.new(pixel_uri)
    pixel_req.body = pixel_post_params.to_json
    pixel_req["X-USER-TOKEN"] = 'fujihalabtoken'

    pixel_res = pixel_http.request(pixel_req)
    pixel_result = JSON.parse(pixel_res.body)

    pixel_result["isSuccess"]
  end

  def delete_pixel(user, date)
    delete_pixel_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs/access-graph/#{date}")
    delete_pixel_http = Net::HTTP.new(delete_pixel_uri.host, delete_pixel_uri.port)

    delete_pixel_http.use_ssl = true
    delete_pixel_http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    delete_pixel_req = Net::HTTP::Delete.new(delete_pixel_uri)
    delete_pixel_req["X-USER-TOKEN"] = 'fujihalabtoken'

    delete_pixel_res = delete_pixel_http.request(delete_pixel_req)
    logger.debug(JSON.parse(delete_pixel_res.body))
    delete_pixel_result = JSON.parse(delete_pixel_res.body)
  end

  private

    def require_sign_in!
      redirect_to login_path unless signed_in?
    end

    def already_sign_in?
      redirect_to root_path if @current_user.present?
    end

    def white_list_ip?
      if ENV['RAILS_ENV'] == 'production' && ENV["LAB_IP_ADDRESS"] != request.remote_ip
        flash[:alert] = "許可されていない端末からのアクセスのため失敗しました。"
        redirect_to login_path
      end
    end

    def slack_notification(message)
      if ENV['RAILS_ENV'] == 'production'
        notifier = Slack::Notifier.new(ENV['PRODUCTION_SLACK_WEBHOOK_URL'])
        notifier.ping(
          message
        )
      else
        notifier = Slack::Notifier.new(ENV['OTHER_SLACK_WEBHOOK_URL'])
        notifier.ping(
          "[#{Rails.env}] #{message}"
        )
      end
    end
end
