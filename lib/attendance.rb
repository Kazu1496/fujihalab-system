module Attendance extend self
  def batch
    now_time = Time.now()
    controller = ApplicationController.new
    users = User.where(status: true)

    users.each do |user|
      latest_existence = user.existences.last
      latest_existence.update(exit_time: now_time - 60)
      
      existences = Existence.where(user_id: user.id)
      total_time = controller.total_time(existences)

      controller.delete_pixel(user, now_time.strftime("%Y%m%d"))
      if controller.create_pixel(user, now_time, total_time)
        user.update!(status: false)
      end

      user.update!(
        status: true,
        total_time: total_time
      )
      user.existences.create(user_id: user.id, enter_time: now_time)
    end
  end
end
