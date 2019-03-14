class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :retina do
    process resize_to_fit: [640, 640]
  end

  version :schema do
    process resize_to_fill: [800, 800, "Center"]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
