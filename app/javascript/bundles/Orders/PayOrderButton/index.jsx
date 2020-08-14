import React, {useState, useEffect} from 'react'
import {loadStripe} from '@stripe/stripe-js';
import {
    CardElement,
    useStripe,
    useElements,
    Elements
} from "@stripe/react-stripe-js";
import getDefaultHeaders from "../../../lib/getDefaultHeaders";

const stripePromise = loadStripe('pk_test_51H9CZeBOcPJ0nbHcn3sfLIpeMPDr4YfdEWe7ytAM7bge9lzgYQTC1uOAFopBIbeKc7i3btFTEGaHSrnBfTwmmu4o00Dz7IGOu6');

export default function PayOrderButton({intent_id}) {

    return (
        <Elements stripe={stripePromise}>
            <div className="w-full flex justify-center items-center px-4">
                <CheckoutButton intent_id={intent_id}/>
            </div>
        </Elements>

    )
}

const CheckoutButton = ({intent_id}) => {
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
        const payload = await stripe.confirmCardPayment(intent_id, {
            //TODO: Update this code
            payment_method: {
                card: elements.getElement(CardElement),
            }
        });
        if (payload.error) {
            setError(`Payment failed ${payload.error.message}`);
            setProcessing(false);
        } else {
            setError(null);
            setProcessing(false);
            // Aquí el pago ya pasó y debemos mandar alv el pinche carrito y toda su sessión
            setSucceeded(true);
        }
    };

    return (
        <>
            <form onSubmit={handleSubmit} className={"w-full my-4"}>
                <div className={"w-full"}>
                    <CardElement id="card-element" options={cardStyle} onChange={handleChange}/>
                </div>
                <button
                    id="submit"
                    disabled={processing || disabled || succeeded}
                    className="bg-black px-6 py-4 w-full text-white mx-auto font-normal">
                    {/*TODO: Agregar un loading*/}
                    <span id="button-text">
                          {processing ? (
                              "Cargando..."
                          ) : (
                              "Siguiente: Terminar y pagar"
                          )}
                        </span>
                </button>
            </form>
        </>
    )
}