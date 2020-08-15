import React from 'react';
import UniqueHeader from "../../../Headers/UniqueHeader";
import ShowCartItems from "../../../Cart/ShowCartItems";
import ShipmentOptions from "../../../Cart/ShippentOptions";
import GetImageUrl from "../../../../lib/getImageUrl";

export default function ScreenCartShow({total = 0, current_cart = {}, items = [], intent_id, client_secret}) {
    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                <UniqueHeader/>
            </div>
            {
                items.length <= 0 &&
                <div className="col-span-12 text-center mt-12">
                    <img
                        className={"h-xl mx-auto mb-12"}
                        src={GetImageUrl({publicId: "utils/flame-777.png", height: 400, width: 400})}
                        alt="Waydda Empty Cart"
                    />
                    <h4 className="text-center text-lg text-gray-700">Aún no tienes productos en tu carrito</h4>
                </div>
            }
            {
                items.length > 0
                &&
                <div className="col-span-12 justify-center items-center mt-8">
                    <div className="w-10/12 flex justify-center mx-auto">
                        <div className="w-8/12">
                            <ShipmentOptions client_secret={client_secret}/>
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
                                    <ShowCartItems items={items} simple={true} withImages={false}/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            }
        </div>
    )
}