import React, {useEffect, useState} from 'react';
import Modal from 'react-modal';
import {FaMapMarkerAlt, FaChevronDown, FaChevronRight, FaChevronLeft} from 'react-icons/fa';
import {IoIosCloseCircle} from 'react-icons/io';
import Input from "../../Forms/Input";

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
                    <ModalSelectMap/>
                    <div className="fixed bottom-0 w-full justify-center flex right-0 bg-white py-4">
                        <button
                            className="bg-black py-3 px-6 w-6/12 text-white focus:outline-none rounded shadow text-sm">
                            Agregar dirección
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

let timer;
const ModalSelectMap = () => {

    const [currentFeatures, setCurrentFeatures] = useState([]);
    const [loading, setLoading] = useState(false);

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
        setLoading(true);
        setFields({...fields, [e.target.name]: e.target.value});
        clearTimeout(timer)
        let newValue = e.target.value;
        timer = setTimeout(async () => {
            try {
                if (newValue.length > 0) {
                    const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(newValue)}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&bbox=-102.36584333677,18.203715736351,-95.646605055518,20.200815919313&proximity=-99.630833,19.354167`
                    let response = await (
                        await fetch(URL, {
                            method: "GET"
                        })
                    ).json();
                    if (typeof response === "object") {
                        setCurrentFeatures(response.features || [])
                        setLoading(false);
                    } else {
                        console.log("Ha ocurrido un error")
                    }
                } else {
                    setCurrentFeatures([]);
                    setLoading(false);
                    console.log("H", newValue)
                }
            } catch (e) {
                setCurrentFeatures([]);
                setLoading(false);
                console.log("Hola", e);
            }
        }, 180)
    }

    const onHandleBlur = () => {
        setLoading(false);
        setCurrentFeatures([]);
    }

    const onHandleClick = (e) => {
        console.log("HOLA", e);
        setFields({...fields, address: e.place_name});
        setCurrentFeatures([]); // Al seleccionar el nuevo address borramos los features
    }

    //Al hacer focus mostramos la dirección si es que se ha cancelado la busqueda anteriormente
    const onHandleFocus = (e) => {
        if (e.target.value.length > 0) {
            if (currentFeatures.length <= 0) {
                handleSearch(e);
            }
        }
    }

    return (
        <>
            <div className="w-full flex flex-wrap px-6 mb-24">
                <div className="relative w-full flex flex-wrap">
                    <Input
                        name={"address"}
                        handleChange={handleSearch}
                        value={fields.address}
                        handleFocus={onHandleFocus}
                        // handleBlur={onHandleBlur}
                        label={"Dirección"}
                        placeholder={"Ingresar dirección"}>
                        <>
                            {
                                currentFeatures.length > 0 &&
                                <div
                                    onClick={onHandleBlur}
                                    className="absolute top-0 p-1 cursor-pointer mr-3 bottom-0 flex items-center right-0">
                                    <IoIosCloseCircle size={14}/>
                                </div>
                            }
                            {
                                currentFeatures.length > 0 &&
                                <div
                                    className="absolute z-50 bg-white shadow transform translate-y-full flex flex-wrap bottom-0 left-0 right-0 justify-center items-center">
                                    {currentFeatures.map((item, k) => (
                                        <ItemAddress
                                            handleClick={onHandleClick}
                                            key={k} item={item}/>
                                    ))}
                                </div>
                            }
                        </>
                    </Input>


                </div>
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

const ItemAddress = ({item, handleClick}) => {
    console.log(item);
    return (
        <div
            onClick={() => handleClick(item)}
            className="flex cursor-pointer gap-4 hover:bg-gray-200 w-full p-2 border-b border-gray-400 text-sm items-center">
            <div className="w-auto flex justify-center">
                <FaMapMarkerAlt
                    className={"inline"}
                    size={14}/>
            </div>
            <div className="w-11/12">
                <p className="font-normal text-gray-700 hover:text-gray-900">{item.place_name}</p>
            </div>
        </div>
    )
}
