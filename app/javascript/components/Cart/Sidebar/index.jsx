import React, {useState} from 'react';
import {RiShoppingBasketLine} from "react-icons/ri";
import classNames from 'classnames'

export default function CartSidebar({items}) {

    const [open, setOpen] = useState(false);

    const sidebarClass = classNames({
        "w-full bg-white transform transition duration-500 delay-75 ease-in-out": true,
        "translate-x-full": !open,
        "translate-x-0": open,
    })

    const sidebarParentClass = classNames({
        "fixed transform translate-y-20 top-0 w-4/12 z-50 flex right-0 bottom-0 h-screen justify-end": true
    })

    const overlayClass = classNames({
        "fixed transform translate-y-20 top-0 w-full flex right-0 bottom-0 h-screen justify-end w-full bg-black sidebar-overlay": true,
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
                className={overlayClass}>
            </div>
            <div
                className={sidebarParentClass}>
                <div
                    className={sidebarClass}>
                    <h3>Carrito</h3>
                </div>
            </div>
        </>
    )
}