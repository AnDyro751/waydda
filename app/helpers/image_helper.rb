module ImageHelper
  # @param [Integer] height
  # @param [Integer] width
  # @param [String] path
  # @return [String] image_url
  def get_image_url(height = 50, width = 50, path = nil, fit = "outside")
    waydda_base_url = "https://d1nrrr6y3ujrjz.cloudfront.net"
    image_request = {
        'bucket': 'waydda-qr',
        'key': path ? path : "places/default.png",
        'edits': {
            'resize': {
                'width': width,
                'height': height,
                'fit': fit,
                "background": {
                    "r": 255,
                    "g": 255,
                    "b": 255,
                    "alpha": 1
                }
            }
        }
    }
    begin
      image_base_64_request = Base64.strict_encode64(image_request.to_json)
      "#{waydda_base_url}/#{image_base_64_request}"
    rescue => e
      puts "----#{e}-#{image_request}"
      "/404.png"
    end
  end
end
