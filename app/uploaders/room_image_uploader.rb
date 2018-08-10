class RoomImageUploader < ApplicationUploader
  process resize_to_limit: [1250, nil]
  version :thumb do
    process resize_to_limit: [500, nil]
  end
end
