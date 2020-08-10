import React, {useState} from 'react'
import AddressModal from "../../Addresses/Modal";
import {RiShoppingBasketLine} from 'react-icons/ri'
import GetImageUrl from "../../../lib/getImageUrl";

export default function HeadersSimple({current_user, current_user_id}) {

    const [addressModalOpen, setAddressModalOpen] = useState(false);

    return (
        <div className="grid grid-cols-12 px-6 py-4 bg-white bg-opacity-75 border-b items-center">
            <div className="col-span-2">
                {/*Crear el componente de imagen responsiva*/}
                <a href="/">
                    <img
                        draggable={false}
                        src={GetImageUrl({publicId: "w_logo.png", width: 50, height: 150})} alt="Waydda logo"
                        className="h-8"/>
                </a>
                {/*<h3 className="font-title text-2xl">Waydda</h3>*/}
            </div>
            <div className="col-span-5 col-start-8">
                <div className="flex w-full gap-12 items-center justify-end">
                    <div className="w-4/12"
                         title={"Calzada México Tacuba"}
                    >
                        <div className="flex w-full flex-wrap">
                            <div className="w-full">
                                <p className="text-gray-500 text-xs">ENTREGAR EN</p>
                            </div>
                            <div className="w-full">
                                <p
                                    className="truncate">Calzada México Tacuba - Torres del toreo 101</p>
                            </div>
                        </div>
                        <AddressModal modalOpen={addressModalOpen} handleClose={() => {
                            setAddressModalOpen(false);
                        }}/>
                        {/* TODO: Agregar funcionalidad */}
                    </div>
                    <div className="w-auto text-center">
                        <RiShoppingBasketLine className="text-gray-800 inline" size={20} title={"Carrito"}/>
                        {/*<span*/}
                        {/*    className="ml-3">Carrito</span>*/}
                        {/* TODO: Agregar funcionalidad */}
                    </div>
                    <div className="w-auto flex justify-center">
                        {
                            current_user ?
                                <a href="/my-profile"
                                   className="rounded-full"
                                >
                                    <img
                                        className="h-8 shadow-lg rounded-full"
                                        src={GetImageUrl({
                                            publicId: "utils/icons8-test-account-96.png",
                                            height: 50,
                                            width: 50
                                        })} alt="Waydda default profile photo"
                                        title={"Mi perfil"}
                                    />
                                </a>
                                :
                                <a href="/users/sign_in"
                                   className="px-6 py-2 rounded border border-black">Ingresar</a>
                        }
                    </div>
                    {/*    Login*/}
                </div>
            </div>
        </div>
    )
}