import React from 'react';
import AddressModal from "../../Addresses/Modal";

export default function Shipment({locations,current_address}) {
    return (
        <div className="w-full">
            <AddressModal
                current_address={current_address}
                modalOpen={false}
                locations={locations}
            />
        </div>
    )
}
