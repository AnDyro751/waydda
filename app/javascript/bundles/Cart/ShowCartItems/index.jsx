import React, {useState, useEffect} from 'react';
import SidebarCartItem from "./Item";

export default function ShowCartItems({items = [], loading = true, withImages = false, simple = true}) {

    const [currentItems, setCurrentItems] = useState(items);

    const handleRemoveItem = (id) => {
        setCurrentItems(currentItems.filter(item => item.string_id !== id));
        console.log("ELIMINANDO ITEM", id)
    }

    return (
        <div className="grid grid-cols-12 w-full">
            <div className="col-span-12">
                {currentItems.length <= 0 &&
                <EmptyCart/>
                }
                <div className="grid grid-cols-12">
                    <div className="col-span-12">
                        {currentItems.map((item, i) => (
                            <SidebarCartItem
                                simple={false}
                                withImages={withImages}
                                removeCartItem={handleRemoveItem}
                                key={i}
                                item={item}
                            />
                        ))}
                    </div>
                </div>

            </div>
        </div>
    )
}


const EmptyCart = () => (
    <div className="w-full text-center my-4">
        <h4>
            Aún no tienes ningún producto en tu carrito
        </h4>
    </div>
)