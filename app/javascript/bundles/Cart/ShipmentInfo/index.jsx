import React, {useEffect, useState} from 'react';
import {AiOutlineClockCircle} from 'react-icons/ai';
import PayOrderButton from "../../Orders/PayOrderButton";

export default function ShipmentInfo({deliveryOption = "delivery", client_secret = null}) {

    const [currentDeliveryOption, setCurrentDeliveryOption] = useState(deliveryOption)

    useEffect(() => {
        setCurrentDeliveryOption(deliveryOption)
    }, [deliveryOption])

    return (
        <div className="flex w-full flex-wrap">
            {
                currentDeliveryOption === "delivery" &&
                <h1>DELIVERY</h1>
            }
            {
                currentDeliveryOption === "pickup" &&
                <>
                    <ShipmentItem
                        title={"Dirección para recoger"}
                        text={"Dolores del rio 430"}
                    />
                    <ShipmentItem
                        title={"Tiempo de recolección"}
                    >
                        <p>
                            <AiOutlineClockCircle className={"inline"}/>&#160;&#160;Listo en <strong>20 minutos</strong>
                        </p>
                    </ShipmentItem>
                </>
            }
            <PayOrderButton client_secret={client_secret}/>
        </div>
    )
}

const ShipmentItem = ({text, children, title}) => (
    <div className="flex my-4 w-full flex-wrap">
        <div className="w-full">
            <h4 className="font-normal mb-3">
                {title}
                {/* TODO: Actualizar esta frase jaja */}
            </h4>
        </div>
        <div className="w-full p-4 border border-gray-400">
            {children ?
                children
                :
                <p className="font-normal text-gray-700">{text}</p>
            }
        </div>

    </div>
)