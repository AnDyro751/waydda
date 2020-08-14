import React, {useState, useEffect} from 'react';
import getDefaultHeaders from "../../../lib/getDefaultHeaders";
import ShowCartItems from "../ShowCartItems";

export default function CartShow({items, total, current_cart, intent_id}) {

    // TODO: Actualizar el contador del carrito al agregar o eliminar un producto
    return (
        <div className="flex w-full gap-4">
            <div className="w-8/12">
                {/*<ShowCartItems*/}
                {/*    intent_id={intent_id}*/}
                {/*    items={items}*/}
                {/*/>*/}
            </div>
            <div className="w-4/12">
                <h1>Total: {total}</h1>
                <h4>{current_cart.quantity} productos</h4>
            </div>
        </div>
    )
}
