import React from 'react';

export default function SelectAddress({addresses, current_address}) {
    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                <h3>Enviar a:</h3>
                <h4 className="truncate">{current_address}</h4>
            </div>
        </div>
    )
}