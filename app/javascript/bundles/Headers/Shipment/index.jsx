import React from 'react';
import AddressModal from "../../Addresses/Modal";

export default function Shipment({locations}) {
    return (
        <div className="w-full">
            <AddressModal
                current_address={null}
                modalOpen={false}
                locations={locations}
            />
        </div>
    )
}
