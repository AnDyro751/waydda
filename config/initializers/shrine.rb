require "shrine"
require "shrine/storage/s3"
s3_options = {
    bucket: "waydda-qr",
    access_key_id: "AKIAYAOMZIQZPJCWNBJJ",
    secret_access_key: "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",
    region: "us-east-1",
}
Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(**s3_options),
    public_store: Shrine::Storage::S3.new(public: true, upload_options: {cache_control: "max-age=15552000"}, **s3_options)
}

Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  # Uppy will send the "filename" and "type" query parameters
  filename = SecureRandom.hex(15)
  type     = request.params["type"]

  {
      content_disposition:    ContentDisposition.inline(filename), # set download filename
      content_type:           type,                                # set content type (required if using DigitalOcean Spaces)
      content_length_range:   0..(10*1024*1024),                   # limit upload size to 10 MB
  }
}