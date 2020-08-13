import React, {useState} from 'react'
import AddressModal from "../../Addresses/Modal";
import GetImageUrl from "../../../lib/getImageUrl";
import CartSidebar from "../../Cart/Sidebar";

export default function HeadersSimple({current_user, current_user_id}) {

    const [addressModalOpen, setAddressModalOpen] = useState(false);

    return (
        <>
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
                    <CartSidebar/>
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
                               className="text-black font-normal hover:text-red-800">Inicia sesión</a>
                    }
                </div>
                {/*    Login*/}
            </div>
        </>
    )
}