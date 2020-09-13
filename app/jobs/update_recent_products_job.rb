class UpdateRecentProductsJob < ApplicationJob
  queue_as :default

  def perform(item_id:, product:, action: "create")
    puts "-----SS----#{item_id}"
    current_item = Item.find_by(id: item_id)
    if action === "create"
      # En create no es necesario validar si el producto ya existe en este item
      if current_item
        puts "----------HAY ITEM"
        current_products = current_item.recent_products
        if current_products.length <= 15
          puts "------------AGREGANDO #{product.name} A RECENT PRODUCTS de #{current_item.name}"
          current_products << product
          # Agregamos el producto
        else
          puts "ELIMINANDO!!!!!!!!"
          last_product = current_products.last
          current_products.delete(last_product)
          current_products << product
          # Eliminamos el ulitmo y agregamos
        end
      end
    elsif action === "delete"
      if current_item
        puts "----------------------------ELIMINANDO #{product.name} de el item de #{current_item.name}"
        current_products = current_item.recent_products
        current_products.delete(product)
      end
      # Recibimos el id del item que se va a actualizar y el producto que se ha eliminado de los items
      # Entonces lo que vamos a hacer es eliminar el producto de este current item, eliminar de recent
    end
    # Do something later
  end
end
