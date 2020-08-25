import React, {useState, useEffect} from 'react'
import {loadStripe} from '@stripe/stripe-js';
import {
    CardElement,
    useStripe,
    useElements,
    Elements
} from "@stripe/react-stripe-js";
import getDefaultHeaders from "../../../lib/getDefaultHeaders";
import {GoCheck} from 'react-icons/go'

const stripePromise = loadStripe('pk_test_51H9CZeBOcPJ0nbHcn3sfLIpeMPDr4YfdEWe7ytAM7bge9lzgYQTC1uOAFopBIbeKc7i3btFTEGaHSrnBfTwmmu4o00Dz7IGOu6');

export default function PayOrderButton({client_secret}) {
    return (
        <Elements stripe={stripePromise}>
            <div className="w-full flex justify-center items-center">
                <CheckoutButton/>
            </div>
        </Elements>

    )
}

const CheckoutButton = ({}) => {
    const [succeeded, setSucceeded] = useState(false);
    const [error, setError] = useState(null);
    const [processing, setProcessing] = useState('');
    const [disabled, setDisabled] = useState(true);
    const stripe = useStripe();
    const elements = useElements();


    const cardStyle = {
        style: {
            base: {
                color: "#32325d",
                fontFamily: 'Arial, sans-serif',
                fontSmoothing: "antialiased",
                fontSize: "16px",
                "::placeholder": {
                    color: "#32325d"
                }
            },
            invalid: {
                color: "#fa755a",
                iconColor: "#fa755a"
            }
        }
    };


    const handleChange = async (event) => {
        // Listen for changes in the CardElement
        // and display any errors as the customer types their card details
        setDisabled(event.empty);
        setError(event.error ? event.error.message : "");
    };


    const handleSubmit = async ev => {
        ev.preventDefault();
        setProcessing(true);
        console.log("SUBMI");
        const {token, error} = await stripe.createToken(elements.getElement(CardElement));
        console.log(token, error);
        if (token) {
            try {
                let response = await fetch("/cart.json", {
                    method: "POST",
                    headers: getDefaultHeaders(),
                    body: JSON.stringify({token_id: token["id"]})
                })
                let jsonResponse = await response.json();
                if (response.status === 201) {
                    setSucceeded(true);
                    setProcessing(false);
                    Turbolinks.visit("/success/id");
                    console.log("PASO JEJE")
                } else {
                    setError(jsonResponse.errors);
                    setProcessing(false);
                    //    OCURRIO UN ERROR
                    console.log(jsonResponse.errors, "ERROR")
                }
            } catch (e) {
                console.log("EEE", e.errors)
            }

        }
    };

    return (
        <>
            <form onSubmit={handleSubmit} className={"w-full my-4"}>
                <div className={"w-full"}>
                    <CardElement id="card-element" options={cardStyle} onChange={handleChange}/>
                </div>
                {error && <p>{error}</p>}
                {
                    succeeded &&
                    <div
                        className={`bg-green-800 px-6 py-4 w-full text-white mx-auto font-normal cursor-not-allowed text-center`}>
                        <span><GoCheck className={"inline"}/>&#160;&#160;Se ha completado tu pago</span>
                    </div>
                }
                {!succeeded &&
                <input
                    type="submit"
                    disabled={processing || disabled || succeeded}
                    className={`bg-black px-6 py-4 w-full text-white mx-auto font-normal ${processing || disabled || succeeded ? "opacity-50 cursor-not-allowed" : "cursor-pointer"}`}
                    // TODO: Agregar un loading
                    value={
                        processing ? (
                            "Cargando..."
                        ) : (
                            "Realizar pedido"
                        )
                    }
                />
                }
            </form>
        </>
    )
}