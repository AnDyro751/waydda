import React from 'react'
import getDefaultHeaders from "../../../lib/getDefaultHeaders";

export default function PayOrderButton({}) {

    const handleClick = async () => {
        try {
            let getResponse = await fetch("/checkout.json", {
                method: "get",
                headers: getDefaultHeaders()
            })
            if (getResponse.status === 401) {
                Turbolinks.visit("/users/sign_in")
            }

            let response = await getResponse.json()
            if (response.error) {
                console.log(response.error)
            }
            console.log(response, response.status)
        } catch (e) {
            console.log("ERROR", e)
        }
    }

    return (
        <div className="w-full flex justify-center items-center px-4">
            <button
                onClick={handleClick}
                className="bg-black px-6 py-4 w-full text-white mx-auto font-normal">
                Siguiente: Terminar y pagar
            </button>
        </div>
    )
}