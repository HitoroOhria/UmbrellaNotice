if defined?(AssetSync)
  AssetSync.configure do |config|
    s3_credentials               = Rails.application.credentials.aws[:s3]
    config.fog_public            = false
    config.fog_provider          = 'AWS'
    config.fog_region            = s3_credentials[:region]
    config.fog_directory         = s3_credentials[:bucket]
    config.aws_access_key_id     = s3_credentials[:access_key]
    config.aws_secret_access_key = s3_credentials[:secret_access_key]
  end
end