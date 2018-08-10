class UserImageUploader < ApplicationUploader
  process resize_to_fill: [400, 400]
  version :thumb do
    process resize_to_fill: [200, 200]
  end
end
