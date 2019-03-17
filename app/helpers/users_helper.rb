module UsersHelper
  def user_image_tag(user, id_name)
    if user.picture.present?
      cl_image_tag(user.picture.retina.filename, width: 80, height: 80, id: id_name)
    else
      image_tag("no_image.png", size: "80x80", id: id_name)
    end
  end
end
