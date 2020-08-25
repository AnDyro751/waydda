import React, {useEffect} from 'react';
import UniqueHeader from "../../../Headers/UniqueHeader";
import ShowCartItems from "../../../Cart/ShowCartItems";
import ShipmentOptions from "../../../Cart/ShippentOptions";
import GetImageUrl from "../../../../lib/getImageUrl";

export default function ScreenCartShow({total = 0, current_cart = {}, cart_items = []}) {
    console.log(cart_items)
    return (
        <div className="grid grid-cols-12">
            {
                cart_items.length > 0
                &&
                <div className="col-span-12 justify-center items-center mt-8">
                    <div className="w-10/12 flex justify-center mx-auto">
                        <div className="w-8/12">
                            <ShipmentOptions/>
                        </div>
                        <div className="w-4/12">
                            <div className="w-full flex flex-wrap">
                                <div className="w-full bg-gray-300 h-40">
                                    {/* TODO: Agregar mapa */}
                                </div>
                                <div className="w-full mt-4">
                                    <h4 className="text-sm font-normal">Nombre del negocio</h4>
                                </div>
                                <div className="w-full">
                                    <ShowCartItems items={cart_items} simple={true} withImages={false}/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            }
        </div>
    )
}