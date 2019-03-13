class ApplicationController < ActionController::Base
  private
    def create_pixel(user, date, existences)
      quantity = stay_time(existences)

      pixel_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs/access-graph")
      pixel_http = Net::HTTP.new(pixel_uri.host, pixel_uri.port)

      pixel_http.use_ssl = true
      pixel_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      pixel_post_params = {
        date: date.strftime("%Y%m%d"),
        quantity: quantity.to_s
      }

      pixel_req = Net::HTTP::Post.new(pixel_uri)
      pixel_req.body = pixel_post_params.to_json
      pixel_req["X-USER-TOKEN"] = user.pixela_token

      pixel_res = pixel_http.request(pixel_req)
      pixel_result = JSON.parse(pixel_res.body)

      pixel_result["isSuccess"]
    end

    def delete_pixel(user, date)
      delete_pixel_uri = URI.parse("https://pixe.la/v1/users/#{user.name}/graphs/access-graph/#{date}")
      delete_pixel_http = Net::HTTP.new(delete_pixel_uri.host, delete_pixel_uri.port)

      delete_pixel_http.use_ssl = true
      delete_pixel_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      delete_pixel_req = Net::HTTP::Delete.new(delete_pixel_uri)
      delete_pixel_req["X-USER-TOKEN"] = user.pixela_token

      delete_pixel_res = delete_pixel_http.request(delete_pixel_req)
      delete_pixel_result = JSON.parse(delete_pixel_res.body)
    end

    def stay_time(existences)
      staytime = 0
      if existences.present?
        existences.each do |existence|
          sec = (existence.exit_time.to_time - existence.enter_time.to_time).to_i
          staytime += sec / 3600
        end
      end
      staytime
    end

    def total_time(user, existences, date)
      existences.each do |existence|
        diff = if date.present?
                 (date - Time.parse(existence.enter_time.to_s)) / 60
               else
                 (existence.exit_time - Time.parse(existence.enter_time.to_s)) / 60
               end
        total_time = diff + user.total
      end
      total_time
    end

    def update_time(current_time, updated_time)
      date = current_time.strftime("%Y%m%d")
      datetime = updated_time.strftime("%H%M")
      updated_date = date + datetime
      updated_date.to_time
    end
end

# 200 Success
def response_success(class_name, action_name)
  render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
end

# 400 Bad Request
def response_bad_request
  render status: 400, json: { status: 400, message: 'Bad Request' }
end

# 401 Unauthorized
def response_unauthorized
  render status: 401, json: { status: 401, message: 'Unauthorized' }
end

# 404 Not Found
def response_not_found(class_name = 'page')
  render status: 404, json: { status: 404, message: "#{class_name.capitalize} Not Found" }
end

# 409 Conflict
def response_conflict(class_name)
  render status: 409, json: { status: 409, message: "#{class_name.capitalize} Conflict" }
end

# 500 Internal Server Error
def response_internal_server_error
  render status: 500, json: { status: 500, message: 'Internal Server Error' }
end
