import React, {useEffect, useState} from 'react';
import Modal from 'react-modal';
import {FaMapMarkerAlt, FaChevronDown, FaChevronRight, FaChevronLeft} from 'react-icons/fa';
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
        margin: 0,
    }
};


export default function AddressModal({
                                         modalOpen = false,
                                         current_address,
                                         locations
                                     }) {
    const [isOpen, setIsOpen] = useState(modalOpen);
    const [currentLocation, setCurrentLocation] = useState(current_address);
    const [currentStep, setCurrentStep] = useState(0);

    const handleOpenModal = () => {
        setIsOpen(true);
    }

    const handleClose = () => {
        setIsOpen(false);
    }

    useEffect(() => {
        Modal.setAppElement("#select-address")
    }, [])

    useEffect(() => {
        if (isOpen) {
            document.querySelector("body").classList.add("overflow-hidden")
        } else {
            document.querySelector("body").classList.remove("overflow-hidden")
        }
    }, [isOpen])

    const onHandleSelectLocation = (newLocation) => {
        setCurrentStep(1);
        // setCurrentLocation(newLocation);
    }

    return (
        <>
            <Modal
                isOpen={true}
                onRequestClose={handleClose}
                style={customStyles}
                ariaHideApp={false}
                contentLabel="Addresses"
                overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-50"
            >
                <div className="w-full flex flex-wrap">
                    <div
                        className="w-full relative  sticky top-0 bg-white z-50 justify-center p-4 border-b border-gray-400 mb-6">
                        <div className="w-full text-center">
                            <h3 className="font-bold text-lg">Ciudad de México</h3>
                        </div>
                        <div
                            onClick={handleClose}
                            className="absolute right-0 top-0 bottom-0 mr-4 flex justify-center items-center p-2 cursor-pointer">
                            <IoIosCloseCircle size={25}/>
                        </div>
                    </div>
                    {/*{*/}
                    {/*    currentStep === 0 ?*/}
                    {/*        <ModalSelectLocation*/}
                    {/*            handleSelectLocation={onHandleSelectLocation}*/}
                    {/*            items={locations}*/}
                    {/*            handleClose={handleClose}*/}
                    {/*        />*/}
                    {/*        :*/}
                    <ModalSelectMap/>
                    <div className="fixed bottom-0 w-full justify-center flex right-0 bg-white py-4">
                        <button className="bg-black py-4 px-6 w-11/12 text-white focus:outline-none">Agregar dirección
                        </button>
                    </div>
                    {/*}*/}
                </div>

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


const ModalSelectMap = () => {

    //TODO: Validar los campos de este formulario
    //Apartment: maxLength: 20
    //external_number: maxLength: 10
    //internal_number: maxLength: 10

    const [fields, setFields] = useState({
        address: "",
        description: "",
    })

    const onHandleChange = (e) => {
        setFields({...fields, [e.target.name]: e.target.value});
    }

    const handleSearch = async (e) => {
        setFields({...fields, [e.target.name]: e.target.value});
        try {
            if (e.target.value.length > 0) {
                const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(e.target.value)}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&bbox=-102.36584333677,18.203715736351,-95.646605055518,20.200815919313&proximity=-99.630833,19.354167`
                console.log(e.target.value, URL);
                let response = await (
                    await fetch(URL, {
                        method: "GET"
                    })
                ).json();
                if (typeof response === "object") {
                    if (response.features.length > 0) {
                        Object.keys(response.features).forEach((k, i) => {
                            let currentItem = response.features[k];
                            console.log(response.features[k], currentItem["id"].split(".")[0])
                        })
                    } else {
                        console.log("No hay records")
                    }
                }
            }
        } catch (e) {
            console.log("Hola", e);
        }
    }

    return (
        <>
            <div className="w-full flex flex-wrap px-6 mb-24">
                <Input
                    name={"address"}
                    handleChange={handleSearch}
                    value={fields.address}
                    label={"Dirección"} placeholder={"Ingresar dirección"}/>
                <Input
                    name={"description"}
                    handleChange={onHandleChange}
                    value={fields.description}
                    label={"Piso / Oficina / Apto / Depto"}
                    placeholder={"Descripción de la dirección (ej. torre, apartamento)"}/>
                <div className="w-full h-56 bg-gray-200">
                    {/*Insertar mapa*/}
                </div>
            </div>

        </>
    )
}

const Input = ({label, placeholder, type = "text", value, handleChange, name}) => (
    <div className="w-full mb-4">
        <label className="text-xs text-gray-700">{label}</label>
        <input type={type}
               name={name}
               value={value}
               onChange={handleChange}
               placeholder={placeholder}
               className="w-full mt-2 py-3 px-4 bg-main-gray focus:outline-none"/>
    </div>
)

const ModalSelectLocation = ({items, handleSelectLocation}) => {
    return (
        <div className="w-full px-6">
            {Array.isArray(items) &&
            items.map((item, i) => (
                <div
                    onClick={() => {
                        handleSelectLocation(item);
                    }}
                    key={i}
                    className="w-full location py-4 relative mb-4 cursor-pointer hover:font-normal opacity-75 hover:opacity-100">
                    <h5>{item.key}</h5>
                    <div className="absolute location-icon flex justify-center items-center bottom-0 top-0 right-0">
                        <FaChevronRight size={14} className={"text-gray-800"}/>
                    </div>
                </div>
            ))
            }
        </div>
    )
}

