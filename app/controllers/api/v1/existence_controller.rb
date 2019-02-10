class Api::V1::ExistenceController < ApplicationController
  protect_from_forgery :except => [:post]

  def post
    # post test
    # ```shell
    # curl -X POST -H "Content-Type: application/json" -d '{"name": "Buri", "status": true}' http://0.0.0.0:3000/api/v1/existence
    # ```




    now_time = Time.now

    name = params[:name]
    status = params[:status]

    user = User.find_or_create_by(name: name)
    existence = user.existences.order(:updated_at).find_or_create_by!(user_id: user.id)


    diff = if existence.enter_time
             (now_time - Time.parse(existence.enter_time.to_s)) / 60
           else
             0
           end

    total = diff + user.total

    if status
      user.update!(status: true)
      existence.update!(enter_time: now_time)
      p 'status = true'
    else
      user.update!(status: false, total: total)
      existence.update!(exit_time: now_time, stay_time: diff)
      p 'status = false'
    end
  end

end
