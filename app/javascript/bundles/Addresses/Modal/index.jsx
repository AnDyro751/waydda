import React, {useEffect, useState} from 'react'
import Modal from 'react-modal';
import {FaMapMarkerAlt} from 'react-icons/fa'

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
            <div
                onClick={() => {
                    setIsOpen(true);
                }}
                style={{
                    backgroundColor: "#F6F6F6"
                }}
                className="flex w-full flex-wrap py-3 px-5 border-b border-gray-400 cursor-pointer">
                <p className="text-gray-700">
                    <FaMapMarkerAlt className={"inline text-black"}/>&#160;&#160;&#160;
                    {
                        current_address ? current_address.street : "Selecciona tu ubicación"
                    }
                </p>
            </div>
        </>
    )
}