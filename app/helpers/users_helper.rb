module UsersHelper
  def user_image_exist(user)
    image_url = user.image.present? ? user.image.retina.to_s : "no_image.png"
  end
end
