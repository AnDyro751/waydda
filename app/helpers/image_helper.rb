module ImageHelper
  # @param [Integer] height
  # @param [Integer] width
  # @param [String] path
  # @return [String] image_url
  def get_image_url(height = 50, width = 50, path = nil)
    waydda_base_url = "https://d1nrrr6y3ujrjz.cloudfront.net"
    image_request = {
        'bucket': 'waydda-qr',
        'key': path ? path : "places/default.png",
        'edits': {
            'resize': {
                'width': 100,
                'height': 40,
                'fit': 'outside'
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
