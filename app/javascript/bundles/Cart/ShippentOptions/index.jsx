import React, {useState} from 'react';
import classNames from 'classnames'

export default function ShipmentOptions({deliveryOption = "delivery"}) {
    const [currentDeliveryOption, setCurrentDeliveryOption] = useState(deliveryOption);
    return (
        <div className="flex w-full">
            <div className="w-8/12">
                <SelectShipment
                    option={currentDeliveryOption}
                    handleSelect={(newOption) => {
                        setCurrentDeliveryOption(newOption);
                    }}
                />
            </div>
        </div>
    )
}

const SelectShipment = ({option}) => {
    const [currentOption, setCurrentOption] = useState(option || "delivery");

    const handleClick = (option) => {
        setCurrentOption(option);
    }

    const itemClass = (option) => {
        return classNames({
            "w-6/12 py-4 text-center cursor-pointer font-normal": true,
            "bg-green-800 text-white border border-green-800": currentOption === option,
            "text-black border": currentOption !== option
        })
    }
    return (
        <div className="flex w-full">
            <div
                onClick={() => handleClick("delivery")}
                className={itemClass("delivery")}>
                Enviar a domicilio
            </div>
            <div
                onClick={() => handleClick("pickup")}
                className={itemClass("pickup")}>
                Recoger en tienda
            </div>
        </div>
    )
}