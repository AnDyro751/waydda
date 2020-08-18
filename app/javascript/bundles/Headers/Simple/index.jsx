import React, {useState} from 'react'
import AddressModal from "../../Addresses/Modal";
import GetImageUrl from "../../../lib/getImageUrl";
import CartSidebar from "../../Cart/Sidebar";

export default function HeadersSimple({current_user, current_user_id, locations}) {

    return (
        <>
            <div className="flex w-full gap-12 items-center justify-end">
                <div className="w-auto text-center">
                    <CartSidebar locations={locations}/>
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
                            <a href="/acceder"
                               className="text-black font-normal hover:text-red-800">Inicia sesión</a>
                    }
                </div>
                {/*    Login*/}
            </div>
        </>
    )
}