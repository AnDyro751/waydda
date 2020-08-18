import React, {useEffect, useState} from 'react'
import Modal from 'react-modal';
import {FaMapMarkerAlt, FaChevronDown} from 'react-icons/fa'
import {RiCloseLine} from 'react-icons/ri';
import {IoIosCloseCircle} from 'react-icons/io';

const customStyles = {
    content: {
        top: '50%',
        left: '50%',
        right: 'auto',
        bottom: 'auto',
        marginRight: '-50%',
        transform: 'translate(-50%, -50%)',
        width: "35%",
        padding: 0,
        margin: 0
    }
};


export default function AddressModal({addresses, modalOpen = false, current_address}) {
    const [isOpen, setIsOpen] = useState(modalOpen);


    const handleOpenModal = () => {
        setIsOpen(true);
    }

    const handleClose = () => {
        setIsOpen(false);
    }

    useEffect(() => {
        Modal.setAppElement(document.querySelector("#select-address"))
    }, [])

    return (
        <>
            <Modal
                isOpen={isOpen}
                onRequestClose={handleClose}
                style={customStyles}
                contentLabel="Addresses"
                overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-25"
            >
                <ModalSelectLocation
                    handleClose={handleClose}
                />
            </Modal>
            <div
                onClick={handleOpenModal}
                style={{
                    boxShadow: "0 6px 10px 0 rgba(128,98,96,.16)"
                }}
                className="flex shadow-2xl py-3 pl-4 pr-10 relative rounded cursor-pointer">
                <div className="absolute ml-4 left-0 top-0 bottom-0 flex justify-center items-center">
                    <FaMapMarkerAlt
                        className={"text-black text-gray-900"}
                        size={20}
                    />
                </div>
                <h4 className="font-normal ml-8 text-gray-800 truncate ">Selecciona tu ubicación</h4>
                <div className="absolute mr-4 right-0 top-0 bottom-0 flex justify-center items-center">
                    <FaChevronDown
                        className="text-gray-900"
                        size={14}
                    />
                </div>
            </div>
            {/*<div*/}
            {/*    style={{*/}
            {/*        backgroundColor: "#F6F6F6"*/}
            {/*    }}*/}
            {/*    className="flex w-full flex-wrap">*/}
            {/*    <p className="text-gray-700">*/}
            {/*        {*/}
            {/*            current_address ? current_address.street : "Ingresa tu dirección para buscar locales cercanos"*/}
            {/*        }*/}
            {/*    </p>*/}
            {/*</div>*/}
        </>
    )
}


const ModalSelectLocation = ({handleClose}) => {
    return (
        <div className="w-full flex flex-wrap">
            <div className="w-full relative justify-center p-4 border-b border-gray-400 mb-6">
                <div className="w-full text-center">
                    <h3 className="font-bold text-lg">Ciudad de México</h3>
                </div>
                <div
                    onClick={handleClose}
                    className="absolute right-0 top-0 bottom-0 mr-6 flex justify-center items-center p-2 cursor-pointer">
                    <IoIosCloseCircle size={25}/>
                </div>
            </div>
        </div>
    )
}

