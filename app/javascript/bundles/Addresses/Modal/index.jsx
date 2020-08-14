import React, {useEffect, useState} from 'react'

import Modal from 'react-modal';

const customStyles = {
    content: {
        top: '50%',
        left: '50%',
        right: 'auto',
        bottom: 'auto',
        marginRight: '-50%',
        transform: 'translate(-50%, -50%)'
    }
};

export default function AddressModal({addresses, modalOpen = false, handleClose, current_address}) {
    const [isOpen, setIsOpen] = useState(modalOpen);

    useEffect(() => {
        setIsOpen(modalOpen);
    }, [modalOpen])

    return (
        <>
            <Modal
                isOpen={isOpen}
                onRequestClose={() => {
                    setIsOpen(false);
                    handleClose()
                }}
                style={customStyles}
                contentLabel="Addresses"
            >

            </Modal>
            <div className="flex w-full flex-wrap">
                <div className="w-full">
                    <p className="text-gray-500 text-xs">ENTREGAR EN</p>
                </div>
                <div className="w-full">
                    <p
                        className="truncate">{current_address}</p>
                </div>
            </div>
        </>
    )
}