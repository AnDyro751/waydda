import React, {useState, useEffect} from 'react';
import getDefaultHeaders from "../../../lib/getDefaultHeaders";

export default function CartShow({items, total, current_cart}) {

    const onHandleDeleteItem = (id) => {
        console.log("Eliminando", id)
    }

    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                <h2>Mostrando carrito</h2>
                <h4>{current_cart.quantity} productos</h4>
            </div>
            <div className="col-span-12">
                <div className="grid grid-cols-12">
                    {items.map((item, i) => {
                        if (item.model_reference) {
                            return (
                                <Item
                                    handleDeleteItem={onHandleDeleteItem}
                                    key={i}
                                    item={item}
                                />
                            )
                        }
                    })}

                </div>
            </div>
        </div>
    )
}

const Item = ({item, handleDeleteItem}) => {
    const [currentQuantity, setCurrentQuantity] = useState(item.quantity);
    const [loading, setLoading] = useState(false);

    const removeCartItem = () => {
        handleDeleteItem(item.string_id)
        console.log("Eliminando item")
    }

    const updateItem = async (quantity, plus = true) => {
        setLoading(true);
        try {
            let response = await (await fetch(`/update_item/${item.model_reference_id}`, {
                method: "put",
                body: JSON.stringify({
                    item: {
                        quantity: parseInt(quantity),
                        plus: plus
                    }
                }),
                headers: getDefaultHeaders()
            })).json()
            if (response.success && response.total_items_counter === null) {
                removeCartItem();
            }
            console.log(response, "Reponse")
            setLoading(false);
        } catch (e) {
            setLoading(false);
            console.log("Ha ocurrido un error", e)
        }

    }

    return (
        <div className="col-span-12 p-3 bg-red-100">
            <div className="grid grid-cols-12">
                <div className="col-span-12">
                    {item.model_reference.name}
                </div>
                <div className="col-span-12">
                    <div className="grid grid-cols-12">
                        <button
                            disabled={loading}
                            className="col-span-4 cursor-pointer" onClick={() => {
                            updateItem(1, false)
                        }}>
                            -
                        </button>
                        <div className="col-span-4">{currentQuantity}</div>
                        <button
                            disabled={loading}
                            className="col-span-4 cursor-pointer"
                            onClick={() => {
                                updateItem(1)
                            }}
                        >+
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}