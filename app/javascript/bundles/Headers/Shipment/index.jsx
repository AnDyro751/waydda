import React from 'react';
import AddressModal from "../../Addresses/Modal";

export default function Shipment() {
    return (
        <div className="w-full">
            <AddressModal
                current_address={null}
                modalOpen={false} handleClose={() => {
                // setAddressModalOpen(false);
            }}/>
            {/* TODO: Agregar funcionalidad */}
        </div>
    )
}
