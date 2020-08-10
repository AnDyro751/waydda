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
    // console.log(string_id)
    const [currentQuantity, setCurrentQuantity] = useState(item.quantity);
    const handleBlur = (e) => {
        setCurrentQuantity(e.target.value);
        if (e.target.value === "0" || e.target.value <= 0) {
            removeCartItem()
        } else {
            updateItem(e.target.value)
        }
    }

    const removeCartItem = () => {
        handleDeleteItem(item.string_id)
        console.log("Eliminando item")
    }

    const updateItem = async (quantity) => {
        console.log("Nueva", quantity)

        try {
            let response = await (await fetch(`/update_item/${item.string_id}`, {
                method: "put",
                body: JSON.stringify({
                    item: {
                        quantity: quantity
                    }
                }),
                headers: getDefaultHeaders()
            })).json()
            console.log(response, "Reponse")
        } catch (e) {
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
                    <input type="number"
                           onChange={(e) => {
                               setCurrentQuantity(e.target.value)
                           }}
                           onBlur={handleBlur}
                           value={currentQuantity}
                    />
                </div>
            </div>
        </div>
    )
}