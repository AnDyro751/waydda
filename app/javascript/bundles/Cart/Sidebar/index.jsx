import React, {useState, useEffect} from 'react';
import {RiShoppingBasketLine} from "react-icons/ri";
import classNames from 'classnames'
import getDefaultHeaders from "../../../lib/getDefaultHeaders";
import {RiCloseLine} from 'react-icons/ri'
import ShowCartItems from "../ShowCartItems";
import AddressModal from "../../Addresses/Modal";
import ReactDOM from 'react-dom'

export default function CartSidebar({locations, current_address}) {

    const [open, setOpen] = useState(false);


    //TODO: Mover esto a algo que no sea un sidebar

    return (
        <>
            <div
                onClick={() => {
                    setOpen(!open)
                }}
                className="flex w-full p-2 cursor-pointer">
                <RiShoppingBasketLine className="text-gray-800 inline" size={20} title={"Carrito"}/>
            </div>
            <Sidebar
                open={open}
                handleOpen={(e) => setOpen(e)}
            />
        </>
    )
    // , document.querySelector("#portal"))
}

const Sidebar = ({handleOpen, open}) => {

    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [currentAddress, setCurrentAddress] = useState(null);
    const [error, setError] = useState(false);

    useEffect(() => {
        console.log(document.querySelector("#portal"), "HOLA")

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
                    setCurrentAddress(response.current_address || null);
                    // console.log(response);
                    setError(false);
                    setLoading(false);
                    console.log(response, "Re")
                } catch (e) {
                    setError(true);
                    console.log(e, "ERROR");
                    setLoading(false);
                }
            }
            getData();
        }
    }, [open])

    const sidebarClass = classNames({
        "w-full bg-white ": true,

    })

    const sidebarParentClass = classNames({
        "fixed transform top-0 w-2/6 z-20 flex right-0 bottom-0 h-screen justify-end transform transition duration-500 delay-75 ease-in-out text-left": true,
        "translate-x-full": !open,
        "translate-x-0": open,
    })
    const overlayClass = classNames({
        "fixed transform z-10 top-0 w-full flex right-0 bottom-0 h-screen justify-end w-full bg-black sidebar-overlay": true,
        "opacity-0 invisible": !open,
        "opacity-50 visible": open
    })
    // if (error) {
    //     return null;
    // }
    return ReactDOM.createPortal(
        <>
            <div
                onClick={() => {
                    handleOpen(false);
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
                            <div className="flex w-full items-center justify-between flex-wrap">
                                <div className="w-8/12">
                                    <h3 className="text-lg font-bold">Carrito</h3>
                                </div>
                                <div className="w-2/12 p-2 cursor-pointer flex justify-end"
                                     onClick={() => {
                                         handleOpen(false);
                                     }}
                                >
                                    <RiCloseLine size={20} className="text-black"/>
                                </div>
                                {
                                    !loading &&
                                    <div className="w-full py-4">
                                        <h4 className="text-sm text-gray-800 mb-4">Entregar en:</h4>
                                        <AddressModal
                                            current_address={currentAddress}
                                            modalOpen={false}
                                        />
                                    </div>
                                }
                            </div>
                        </div>

                        <div className="col-span-12">
                            <ShowCartItems
                                withImages={false}
                                items={items}
                            />
                        </div>
                    </div>
                </div>
            </div>
        </>
        , document.querySelector("#portal"))
}