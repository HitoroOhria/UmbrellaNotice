module StaticPagesHelper
  def image_url(file_name)
    case Rails.env
    when 'production'
      s3_secret   = Rails.application.credentials.aws.s3
      credentials = Aws::Credentials.new(s3_secret[:access_key], s3_secret[:secret_access_key])
      client      = Aws::S3::Client.new(credentials: credentials)
      signer      = Aws::S3::Presigner.new(client: client)
      obj_key     = "images/#{file_name}.png"
      signer.presigned_url(:get_object, bucket: s3_secret[:bucket], key: obj_key, expires_in: 60)
    when 'development'
      file_name
    end
  end
end
