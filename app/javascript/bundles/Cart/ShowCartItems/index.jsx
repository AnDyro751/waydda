import React from 'react';
import {BsFillTrashFill} from 'react-icons/bs';
import {GoPlus} from 'react-icons/go'
import {FaMinus} from 'react-icons/fa'

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
                <Item
                    key={i}
                    item={item}
                />
            ))}
        </div>
    </div>
)

const Item = ({item}) => (
    <div className="flex w-full mb-4 border-b border-gray-200 py-4 px-2">
        <div className="w-2/12">
        </div>
        <div className="w-10/12">
            <div className="flex w-full items-center gap-2">
                <div className="w-5/12">
                    <p className="font-bold">
                        {item.model_reference.name}
                    </p>
                    <p className="text-xs">
                        {item.model_reference.description}
                    </p>
                </div>
                <div className="w-4/12">
                    <div className="flex w-full text-center gap-2 justify-between">
                        <button
                            // disabled={loading}
                            className="h-10 w-10 cursor-pointer hover:bg-gray-900 rounded flex justify-center items-center hover:text-white"
                            onClick={() => {
                                // updateItem(1, false)
                            }}>
                            {item.quantity <= 1 &&
                            <BsFillTrashFill size={13} className={""}/>
                            }
                            {item.quantity > 1 &&
                            <FaMinus size={13} className={""}/>
                            }
                        </button>
                        <div
                            className="flex justify-center items-center border border-gray-300 h-10 w-10 rounded">{item.quantity}</div>
                        <button
                            // disabled={loading}
                            className="h-10 w-10 cursor-pointer hover:bg-gray-900 rounded flex justify-center items-center hover:text-white"
                            onClick={() => {
                                // updateItem(1)
                            }}
                        >
                            <GoPlus size={13} className={""}/>
                        </button>
                    </div>
                </div>
                <div className="w-3/12 text-center">
                    <span className="text-gray-700">
                        MXN {item.model_reference.price * item.quantity}
                    </span>
                </div>
            </div>
        </div>
    </div>
)

const LoadingSpinner = () => (
    <div className="w-full text-center flex justify-center">
        <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-black" xmlns="http://www.w3.org/2000/svg" fill="none"
             viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/>
            <path className="opacity-75" fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
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