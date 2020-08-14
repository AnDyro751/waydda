import React, {useState, useEffect} from 'react';
import {RiShoppingBasketLine} from "react-icons/ri";
import classNames from 'classnames'
import getDefaultHeaders from "../../../lib/getDefaultHeaders";
import {RiCloseLine} from 'react-icons/ri'
import ShowCartItems from "../ShowCartItems";

export default function CartSidebar({}) {

    const [open, setOpen] = useState(false);
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [didMount, setDidMount] = useState(false);
    useEffect(() => {
        setDidMount(true);
        if (open) {
            const getData = async () => {
                try {
                    let response = await (
                        await fetch("/cart.json", {
                            method: "get",
                            headers: getDefaultHeaders()
                        })
                    ).json()
                    setItems(response.items || [])
                    setLoading(false);
                    console.log(response, "Re")
                    return () => setDidMount(false);
                } catch (e) {
                    setLoading(false);
                }
            }
            getData();
        }
        return () => setDidMount(false);
    }, [open])

    const sidebarClass = classNames({
        "w-full bg-white ": true,

    })

    const sidebarParentClass = classNames({
        "fixed transform top-0 w-2/5 z-10 flex right-0 bottom-0 h-screen justify-end transform transition duration-500 delay-75 ease-in-out text-left": true,
        "translate-x-full": !open,
        "translate-x-0": open,
    })

    const overlayClass = classNames({
        "fixed transform top-0 w-full flex right-0 bottom-0 h-screen justify-end w-full bg-black sidebar-overlay": true,
        "opacity-0 invisible": !open,
        "opacity-50 visible": open
    })

    return (
        <>
            <div
                onClick={() => {
                    setOpen(!open)
                }}
                className="flex w-full p-2 cursor-pointer">
                <RiShoppingBasketLine className="text-gray-800 inline" size={20} title={"Carrito"}/>
            </div>
            <div
                onClick={() => {
                    setOpen(false);
                }}
                className={overlayClass}>
            </div>
            <div
                className={sidebarParentClass}>
                <div
                    className={sidebarClass}>
                    <div className="grid grid-cols-12 relative">
                        <div className="col-span-12 p-4 border-b relative"
                             style={{
                                 backgroundColor: "#fafafa"
                             }}
                        >
                            <div className="flex w-full items-center justify-between">
                                <div className="w-8/12">
                                    <h3 className="text-lg font-bold">Carrito</h3>
                                </div>
                                <div className="w-auto p-2 cursor-pointer flex justify-end"
                                     onClick={() => {
                                         setOpen(false);
                                     }}
                                >
                                    <RiCloseLine size={20} className="text-black"/>
                                </div>
                            </div>
                        </div>
                        <div className="col-span-12">
                            <ShowCartItems
                                items={items}
                            />
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}