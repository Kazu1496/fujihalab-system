require 'net/https'
require 'open-uri'
require 'securerandom'

class Api::V1::ExistenceController < ApplicationController
  protect_from_forgery :except => [:post]

  def post
    # post test
    # ```shell
    # curl -X POST -H "Content-Type: application/json" -d '{"name": "Buri", "status": true}' http://0.0.0.0:3000/api/v1/existence
    # ```
    now_time = Time.now()
    name = params[:name].downcase
    password = params[:password]
    status = params[:status]
    user = User.find_by(name: name)

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
      else
        render json: {status: 400, message: "User create faild..."}
      end
    end


    if status
      existence = user.existences.order(:updated_at).create(user_id: user.id)
      user.update!(status: true)
      existence.update!(enter_time: now_time)
    else
      existence = user.existences.order(enter_time: :desc).take
      diff = if existence.enter_time
               (now_time - Time.parse(existence.enter_time.to_s)) / 60
             else
               0
             end

      total = diff + user.total

      # CreatePixel
      picel_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs/access-graph")
      picel_http = Net::HTTP.new(picel_uri.host, picel_uri.port)

      picel_http.use_ssl = true
      picel_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      picel_post_params = {
        date: now_time.strftime("%Y%m%d"),
        quantity: "4"
      }

      picel_req = Net::HTTP::Post.new(picel_uri)
      picel_req.body = picel_post_params.to_json
      picel_req["X-USER-TOKEN"] = user.pixela_token

      picel_res = picel_http.request(picel_req)
      picel_result = JSON.parse(picel_res.body)

      if picel_result["isSuccess"]
        user.update!(status: false, total: total)
        existence.update!(exit_time: now_time)
      else
        render json: {status: 400, message: "Pixel create faild..."}
      end
    end
  end
end
