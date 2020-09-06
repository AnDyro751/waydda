module LinkHelper
  # @param [String] link
  # @param [String] active_class
  # @param [String] default_class
  # @return [Object] rails link_to
  def active_link_to(default_text, link, active_class, default_class, current_routes = nil)
    if current_routes.nil?
      link_to default_text, link, class: "#{current_page?(link) ? active_class : ""} #{default_class}"
    else
      link_to default_text, link, class: "#{current_routes.include?(request.path) ? active_class : ""} #{default_class}"
    end
  end
end
