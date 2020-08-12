import React, {useState, useEffect} from 'react';
import SidebarCartItem from "./Item";
import LoaderSpinners from "../../Loaders/Spinner";

export default function ShowCartItems({items = [], loading = true}) {

    const [currentItems, setCurrentItems] = useState([]);

    const handleRemoveItem = (id) => {
        setCurrentItems(currentItems.filter(item => item.string_id !== id));
        console.log("ELIMINANDO ITEM", id)
    }

    useEffect(() => {
        let mounted = true
        if (mounted) {
            setCurrentItems(items);
        }
        return () => mounted = false;
    }, [items])

    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                {/*{currentItems.length <= 0 &&*/}
                {/*<EmptyCart/>*/}
                {/*}*/}
                <RenderItems items={currentItems}
                             onRemoveCartItem={handleRemoveItem}
                />
            </div>
        </div>
    )
}


const RenderItems = ({items = [], onRemoveCartItem}) => (
    <div className="grid grid-cols-12">
        <div className="col-span-12">
            {items.map((item, i) => (
                <SidebarCartItem
                    removeCartItem={onRemoveCartItem}
                    key={i}
                    item={item}
                />
            ))}
        </div>
    </div>
)


const EmptyCart = () => (
    <div className="w-full text-center my-4">
        <h4>
            Aún no tienes ningún producto en tu carrito
        </h4>
    </div>
)