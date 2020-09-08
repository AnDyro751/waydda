module Dashboard::MainHelper

  def main_button(to:, custom_class: nil, text:, class_icon: nil, action: nil)
    link_to to, class: "#{custom_class ? custom_class : "bg-white shadow hover:shadow-lg py-2 px-4 transition duration-150 font-normal text-sm border text-black rounded border-gray-400 border-2"}" do
      data = "<span>
            #{
      if action
        if action === "add"
          "
          <svg xmlns='http://www.w3.org/2000/svg' x='0px' y='0px'
          class='#{class_icon ? class_icon : 'inline h-4 fill-current text-gray-800'}'
          viewBox='0 0 24 24'><path fill-rule='evenodd' d='M 11 2 L 11 11 L 2 11 L 2 13 L 11 13 L 11 22 L 13 22 L 13 13 L 22 13 L 22 11 L 13 11 L 13 2 Z'></path></svg>
        "
        else
          "<svg xmlns='http://www.w3.org/2000/svg' x='0px' y='0px'
    viewBox='0 0 24 24'
    class='#{class_icon ? class_icon : 'inline h-4 fill-current text-gray-800'}'
    >    <path d='M 18 2 L 16 4 L 20 8 L 22 6 L 18 2 z M 14.5 5.5 L 5 15 C 5 15 6.005 15.005 6.5 15.5 C 6.995 15.995 6.984375 16.984375 6.984375 16.984375 C 6.984375 16.984375 8.004 17.004 8.5 17.5 C 8.996 17.996 9 19 9 19 L 18.5 9.5 L 14.5 5.5 z M 3.6699219 17 L 3 21 L 7 20.330078 L 3.6699219 17 z'></path></svg>"
        end
      end
      }
    &#160;&#160;#{text}
      </span>"
      data.html_safe
    end
    # link_to edit_dashboard_product_path(@product.slug), class: "bg-white shadow hover:shadow-lg py-2 px-4 transition duration-150 font-normal text-sm border text-black rounded border-gray-400 border-2" do %>
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