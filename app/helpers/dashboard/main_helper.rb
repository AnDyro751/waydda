module Dashboard::MainHelper

  def current_active_class(page, classnames)
    if current_page?(page)
      return classnames
    end
  end

  def label_color_class(size: "small")
    "#{size === "big" ? "text-base font-medium text-gray-900" : "font-normal text-sm text-gray-600 "}"
  end

  def input_color_class(padding: "small")
    "bg-main-gray rounded outline:none focus:outline-none px-4 py-3 w-full focus:bg-white border-2 border-transparent focus:border-gray-300"
  end

  # @param [String] color
  # @param [String] custom_class
  # @return [String]
  def main_color_button(color: "", custom_class: nil, size: "small", padding: "small", with_shadow: false, padding_class: nil)
    if color === "secondary"
      "#{custom_class ? custom_class : ""} bg-main-blue #{size != "small" ? "px-6" : "px-4" } hover:bg-opacity-75 cursor-pointer transform relative #{padding_class ? padding_class : padding === "small" ? "py-2 text-sm" : "py-3"} transition duration-150 font-medium #{with_shadow ? "shadow-main border-2" : ""}  text-white rounded border-black"
    elsif color === "primary"
      "#{custom_class ? custom_class : ""} bg-main-teal #{size != "small" ? "px-6" : "px-4" } hover:bg-opacity-75 cursor-pointer transform relative #{padding_class ? padding_class : padding === "small" ? "py-2 text-sm" : "py-3"} transition duration-150 font-medium #{with_shadow ? "shadow-main border-2" : ""}  text-black rounded border-black"
    elsif color === "danger"
      "#{custom_class ? custom_class : ""} bg-main-red #{size != "small" ? "px-6" : "px-4" } hover:bg-opacity-75 cursor-pointer transform  relative #{padding_class ? padding_class : padding === "small" ? "py-2 text-sm" : "py-3"} transition duration-150 font-medium #{with_shadow ? "shadow-main border-2" : ""}  text-white rounded border-black"
    elsif color === "dark"
      "#{custom_class ? custom_class : ""} bg-main-dark #{size != "small" ? "px-6" : "px-4" } hover:bg-opacity-75 cursor-pointer transform  relative #{padding_class ? padding_class : padding === "small" ? "py-2 text-sm" : "py-3"} transition duration-150 font-medium #{with_shadow ? "shadow-main border-2" : ""}  text-white rounded border-black"
    else
      "#{custom_class ? custom_class : ""} bg-main-gray-dark #{size != "small" ? "px-6" : "px-4" } hover:bg-main-gray cursor-pointer transform  relative #{padding_class ? padding_class : padding === "small" ? "py-2 text-sm" : "py-3"} transition duration-150 font-medium #{with_shadow ? "shadow-main border-2" : ""}  text-black rounded border-black"
    end
  end


  # @param [String] to
  # @param [String] custom_class
  # @param [String] text
  # @param [String] class_icon
  # @param [String] action
  # @return [ActiveSupport::SafeBuffer]
  def main_button(to:, custom_class: nil, remote: false, text:, class_icon: nil, action: nil, custom_click: nil, with_shadow: false, color_button: "")
    link_to to, class: main_color_button(color: color_button, size: "big", padding: "big", with_shadow: with_shadow), remote: remote, "@click": "#{custom_click ? custom_click : nil}" do
      data = "<span>
            #{
      if action
        if action === "add"
          "
          <svg xmlns='http://www.w3.org/2000/svg' x='0px' y='0px'
          class='#{class_icon ? class_icon : 'inline h-4 fill-current'}'
          viewBox='0 0 24 24'><path fill-rule='evenodd' d='M 11 2 L 11 11 L 2 11 L 2 13 L 11 13 L 11 22 L 13 22 L 13 13 L 22 13 L 22 11 L 13 11 L 13 2 Z'></path></svg>
        "
        else
          "<svg xmlns='http://www.w3.org/2000/svg' x='0px' y='0px'
    viewBox='0 0 24 24'
    class='#{class_icon ? class_icon : 'inline h-4 fill-current'}'
    >    <path d='M 18 2 L 16 4 L 20 8 L 22 6 L 18 2 z M 14.5 5.5 L 5 15 C 5 15 6.005 15.005 6.5 15.5 C 6.995 15.995 6.984375 16.984375 6.984375 16.984375 C 6.984375 16.984375 8.004 17.004 8.5 17.5 C 8.996 17.996 9 19 9 19 L 18.5 9.5 L 14.5 5.5 z M 3.6699219 17 L 3 21 L 7 20.330078 L 3.6699219 17 z'></path></svg>"
        end
      end
      }
    &#160;&#160;#{text}
      </span>"
      data.html_safe
    end
    # link_to edit_dashboard_product_path(@product), class: "bg-white shadow hover:shadow-lg py-2 px-4 transition duration-150 font-normal text-sm border text-black rounded border-gray-400 border-2" do %>
    #   <span>
    #     <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px"
    # viewBox="0 0 24 24"
    # class="inline h-4 fill-current text-gray-800"
    # >    <path d="M 18 2 L 16 4 L 20 8 L 22 6 L 18 2 z M 14.5 5.5 L 5 15 C 5 15 6.005 15.005 6.5 15.5 C 6.995 15.995 6.984375 16.984375 6.984375 16.984375 C 6.984375 16.984375 8.004 17.004 8.5 17.5 C 8.996 17.996 9 19 9 19 L 18.5 9.5 L 14.5 5.5 z M 3.6699219 17 L 3 21 L 7 20.330078 L 3.6699219 17 z"></path></svg>
    # & #160;&#160;Actualizar producto
    # </span>
    # end
  end

end
