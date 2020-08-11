import React from 'react';

export default function ShowCartItems({items = [], loading = true}) {

    return (
        <div className="grid grid-cols-12">
            <div className="col-span-12">
                {
                    loading &&
                    <LoadingSpinner/>
                }
                {items.length <= 0 && !loading &&
                <EmptyCart/>
                }
                {
                    items.length > 0 && !loading &&
                    <RenderItems items={items}/>
                }
            </div>
        </div>
    )
}


const RenderItems = ({items = []}) => (
    <div className="grid grid-cols-12">
        <div className="col-span-12">
            {items.map((item, i) => (
                <div key={i} className="flex w-full">
                    <div className="w-2/12">

                    </div>
                    <div className="w-10/12">
                        <p className="font-bold">
                            {item.model_reference.name}
                        </p>
                        <p className="text-xs">
                            MXN {item.model_reference.price} x {item.quantity}
                        </p>
                    </div>
                </div>
            ))}
        </div>
    </div>
)

const LoadingSpinner = () => (
    <div className="w-full text-center flex justify-center">
        <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-black" xmlns="http://www.w3.org/2000/svg" fill="none"
             viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
    </div>
)

const EmptyCart = () => (
    <div className="w-full text-center my-4">
        <h4>
            Aún no tienes ningún producto en tu carrito
        </h4>
    </div>
)