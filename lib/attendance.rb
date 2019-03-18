module Attendance extend self
  def batch
    now_time = Time.now()
    controller = ApplicationController.new
    users = User.where(status: true)

    users.each do |user|
      latest_existence = user.existences.order(:created_at).last
      existences = Existence.where(user_id: user.id)
      total_time = controller.total_time(existences)

      controller.delete_pixel(user, now_time.strftime("%Y%m%d"))
      if controller.create_pixel(user, now_time, total_time)
        user.update!(status: false)
        latest_existence.update!(exit_time: now_time - 61)
      end

      user.update!(
        status: true,
        total_time: total_time
      )
      next_existence = user.existences.order(:created_at).create(user_id: user.id)
      next_existence.update!(enter_time: now_time - 60)
    end
  end
end
