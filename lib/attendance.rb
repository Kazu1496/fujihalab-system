module Attendance extend self
  def batch
    now_time = Time.now()
    controller = ApplicationController.new
    users = User.where(status: true)

    users.each do |user|
      latest_existence = user.existences.order(:updated_at).last
      existences = Existence.where(
        user_id: user.id,
        enter_time: latest_existence.enter_time.in_time_zone.all_day
      )

      user.update!(status: false)
      latest_existence.update!(exit_time: now_time - 1)

      user.update!(status: true)
      next_existence = user.existences.order(:created_at).create(user_id: user.id)
      next_existence.update!(enter_time: now_time + 60)
    end
  end
end
