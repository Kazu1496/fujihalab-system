class PictureUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :retina do
    process resize_to_fit: [640, 640]
  end

  version :schema do
    process resize_to_fill: [800, 800, "Center"]
  end
end
