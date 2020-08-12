import {BsFillTrashFill} from "react-icons/bs";
import {FaMinus} from "react-icons/fa";
import {GoPlus} from "react-icons/go";
import React, {useState, useEffect} from "react";
import getDefaultHeaders from "../../../../lib/getDefaultHeaders";
import LoaderSpinners from "../../../Loaders/Spinner";

export default function SidebarCartItem({item, removeCartItem}) {
    const [currentItem, setCurrentItem] = useState(null);
    const [loading, setLoading] = useState(false);
    const [addLoading, setAddLoading] = useState(false);
    const [minusLoading, setMinusLoading] = useState();


    useEffect(() => {
        let mounted = true;
        if (mounted) {
            setCurrentItem(item);
        }
        return () => mounted = false;
    }, [item])


    const updateItem = async (quantity, plus = true) => {
        setLoading(true);
        plus && setAddLoading(true);
        !plus && setMinusLoading(true);
        try {
            let response = await (await fetch(`/update_item/${currentItem.model_reference_id}`, {
                method: "put",
                body: JSON.stringify({
                    item: {
                        quantity: parseInt(quantity),
                        plus: plus
                    }
                }),
                headers: getDefaultHeaders()
            })).json()
            if (!response.success) {
                console.log("Ha ocurrido un error")
            }
            if (response.success && response.total_items_counter === null) {
                removeCartItem(currentItem.string_id);
            }
            if (response.success && response.total_items_counter) {
                setCurrentItem({...currentItem, quantity: response.total_items_counter});
            }
            console.log(response, "Reponse")
            setLoading(false);
            setAddLoading(false);
            setMinusLoading(false);
        } catch (e) {
            setLoading(false);
            setLoading(false);
            setAddLoading(false);
            console.log("Ha ocurrido un error", e)
        }

    }

    if (!currentItem) {
        return null;
    }

    return (
        <div className="flex w-full mb-4 border-b border-gray-200 py-4 px-2">
            <div className="w-2/12">
            </div>
            <div className="w-10/12">
                <div className="flex w-full items-center gap-2">
                    <div className="w-5/12">
                        <p className="font-bold">
                            {currentItem.model_reference.name}
                        </p>
                        <p className="text-xs">
                            {currentItem.model_reference.description}
                        </p>
                    </div>
                    <div className="w-4/12">
                        <div className="flex w-full text-center gap-2 justify-between">
                            <button
                                disabled={loading}
                                className={`h-10 w-10 cursor-pointer hover:bg-gray-900 rounded flex justify-center items-center hover:text-white ${minusLoading ? "bg-gray-900 cursor-not-allowed" : ""}`}
                                onClick={() => {
                                    updateItem(1, false)
                                }}>
                                {
                                    minusLoading ?
                                        <LoaderSpinners className={minusLoading ? "text-white" : ""}/>
                                        :
                                        <>
                                            {currentItem.quantity <= 1 &&
                                            <BsFillTrashFill size={13} className={""}/>
                                            }
                                            {currentItem.quantity > 1 &&
                                            <FaMinus size={13} className={""}/>
                                            }
                                        </>
                                }
                            </button>
                            <div
                                className="flex justify-center items-center border border-gray-300 h-10 w-10 rounded">{currentItem.quantity}</div>
                            <button
                                disabled={addLoading}
                                className={`h-10 w-10 cursor-pointer disabled:cursor-not-allowed hover:bg-gray-900 rounded flex justify-center items-center hover:text-white ${addLoading ? "bg-gray-900 cursor-not-allowed" : ""}`}
                                onClick={() => {
                                    updateItem(1)
                                }}
                            >
                                {
                                    addLoading ?
                                        <LoaderSpinners className={addLoading ? "text-white" : ""}/>
                                        :
                                        <GoPlus size={13} className={""}/>


                                }
                            </button>
                        </div>
                    </div>
                    <div className="w-3/12 text-center">
                    <span className="text-gray-700">
                        MXN {currentItem.model_reference.price * currentItem.quantity}
                    </span>
                    </div>
                </div>
            </div>
        </div>

    )
}