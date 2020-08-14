import React, {useState, useEffect} from 'react';
import SidebarCartItem from "./Item";
import LoaderSpinners from "../../Loaders/Spinner";
import PayOrderButton from "../../Orders/PayOrderButton";

export default function ShowCartItems({items = [], loading = true, intent_id}) {

    const [currentItems, setCurrentItems] = useState(items);

    const handleRemoveItem = (id) => {
        setCurrentItems(currentItems.filter(item => item.string_id !== id));
        console.log("ELIMINANDO ITEM", id)
    }

    useEffect(() => {
        setCurrentItems(items);
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
                                removeCartItem={handleRemoveItem}
                                key={i}
                                item={item}
                            />
                        ))}
                    </div>
                </div>


                {
                    currentItems.length > 0 &&
                    <PayOrderButton intent_id={intent_id}/>
                }

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