if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      region: "ap-northeast-1",
      aws_access_key_id: ENV["S3_ACCESS_KEY"],
      aws_secret_access_key: ENV["S3_SECRET_KEY"],
    }
    config.asset_host = "https://bestcode.reviews"
    config.fog_directory = "bestcode-app"
    config.cache_storage = :fog
    config.fog_attributes = { "Cache-Control" => "max-age=315576000" }
  end
end
