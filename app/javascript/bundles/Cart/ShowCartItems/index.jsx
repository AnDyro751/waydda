import React, {useState, useEffect} from 'react';
import SidebarCartItem from "./Item";

export default function ShowCartItems({items = [], loading = true, withImages = false, simple = false}) {

    const [currentItems, setCurrentItems] = useState(items || []);

    const handleRemoveItem = (id) => {
        setCurrentItems(currentItems.filter(item => item.string_id !== id));
        console.log("ELIMINANDO ITEM", id)
    }

    useEffect(() => {
        if (items) {
            setCurrentItems(items);
        }
    }, [items])

    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                {currentItems.length <= 0 &&
                <EmptyCart/>
                }
                <div className="grid grid-cols-12">
                    <div className="col-span-12">
                        {currentItems.map((item, i) => (
                            <SidebarCartItem
                                simple={simple}
                                withImages={withImages}
                                removeCartItem={handleRemoveItem}
                                key={i}
                                item={item}
                            />
                        ))}
                    </div>
                </div>

                {
                    currentItems.length > 0 &&
                    <div className={`grid grid-cols-12 ${simple ? "" : "px-3"}`}>
                        <div className="col-span-12 text-center">
                            <a href="/cart"
                               className="bg-green-800 text-white font-normal py-4 w-full flex justify-center">
                                Siguiente: Revisar y pagar
                            </a>
                        </div>
                    </div>
                }

                {/*{*/}
                {/*    currentItems.length > 0 &&*/}
                {/*    <PayOrderButton intent_id={intent_id}/>*/}
                {/*}*/}

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