import React, {useState} from "react";
import GetImageUrl from "../../../lib/getImageUrl";
import {FaChevronDown, FaChevronUp} from "react-icons/fa";
import ShowCartItems from "../ShowCartItems";
import {BsFillTrashFill} from "react-icons/bs";

export default function CartItem({cart}) {
    const [open, setOpen] = useState(false);
    const handleClick = () => {
        setOpen(!open)
    }
    return (
        <div className="w-full flex mb-4 py-4 flex-wrap border-b pb-4">
            <div className="w-full flex gap-4 px-3 items-center mb-2 pb-4 border-b">
                <div className="w-auto">
                    <img
                        className="w-10 h-10 rounded shadow-lg bg-gray-300"
                        src={GetImageUrl({publicId: cart.place_record.photo})}
                        alt={`logo de ${cart.place_record.name}`}/>
                </div>
                <div className="w-10/12">
                    <h4 className="font-bold">{cart.place_record.name}</h4>
                </div>
                <div
                    onClick={handleClick}
                    className="w-1/12 cursor-pointer p-2">
                    {
                        open ?
                            <FaChevronUp/>
                            :
                            <FaChevronDown/>
                    }
                </div>
            </div>
            {
                open &&
                <ShowCartItems
                    withImages={false}
                    items={cart.items}
                />
            }
            <div className="w-full flex gap-4 px-3 items-center mt-4">
                <div className="w-6/12">
                    <div className="text-sm text-gray-700">
                        <BsFillTrashFill className={"text-gray-600 inline"} size={14}/>&#160;&#160;
                        <span className="cursor-pointer py-1">Eliminar pedido</span>
                    </div>
                </div>
                <div className="w-7/12">
                    <div className="w-full text-center">
                        <a href={`/places/${cart.place_record.slug}/cart`}
                           className="bg-black shadow text-white rounded py-2 w-full flex justify-center">
                            Pagar
                        </a>
                    </div>
                </div>
            </div>
        </div>
    )
}