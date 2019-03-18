module UsersHelper
  def user_image_tag(user, id_name, width, height)
    if user.picture.present?
      cl_image_tag(user.picture.retina.filename, width: width, height: height, id: id_name, alt: "#{user_name(user)}のプロフィール画像")
    else
      image_tag("no_image.png", widrh: width, height: height, id: id_name, alt: "#{user_name(user)}のプロフィール画像")
    end
  end

  def user_name(user)
    name = user.nickname.present? ? user.nickname : user.name
  end
end
