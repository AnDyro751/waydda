class Dashboard::ImageController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  Aws.config.update({credentials: Aws::Credentials.new('AKIAYAOMZIQZPJCWNBJJ', 'zpssqm5AuysJoLswNmBwM3FXNjbArioB74it8Zjr')})

  def upload
    render json: {image_url: nil}, status: :unprocessable_entity if params["files"].nil?
    render json: {image_url: nil}, status: :unprocessable_entity if params["files"].length <= 0
    model = params["model"].titleize.constantize
    image_file = params["files"][0]
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    extname = File.extname(image_file.original_filename)
    filename = "#{SecureRandom.uuid}#{extname}"
    bucket_filename = "#{params["model"]}/#{params["slug"]}/#{filename}"
    obj = s3.bucket("waydda-qr").object(bucket_filename)
    obj.upload_file(image_file.tempfile)
    update_response = model.update_attribute(params["attribute"], params["slug"], bucket_filename, current_user)
    if update_response[:error]
      render json: {image_url: nil, error: update_response[:error]}, status: :unprocessable_entity
    else
      render json: {image_url: bucket_filename}, status: :ok
    end
  end
end
