import React, {useEffect, useState} from 'react';
import Modal from 'react-modal';
import {FaMapMarkerAlt, FaChevronDown, FaChevronRight, FaChevronLeft} from 'react-icons/fa';
import {IoIosCloseCircle} from 'react-icons/io';
import Input from "../../Forms/Input";
import MapComponent from "../../Place/Map";
import getDefaultHeaders from "../../../lib/getDefaultHeaders";

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
    const [currentLocation, setCurrentLocation] = useState(current_address || null);
    const [currentStep, setCurrentStep] = useState(0);
    const [fields, setFields] = useState({
        address: "",
        current: true,
        lat: 0,
        lng: 0,
        description: ""
    })

    const handleOpenModal = () => {
        setIsOpen(true);
    }

    const handleClose = () => {
        setIsOpen(false);
    }

    useEffect(() => {
        Modal.setAppElement("#select-address")
        console.log(current_address, currentLocation);
    }, [])

    useEffect(() => {
        if (isOpen) {
            document.querySelector("body").classList.add("overflow-hidden")
        } else {
            document.querySelector("body").classList.remove("overflow-hidden")
        }
    }, [isOpen])

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            let response = await (await fetch("/addresses", {
                method: "POST",
                headers: getDefaultHeaders(),
                body: JSON.stringify({
                    address: {
                        current: true,
                        address: fields.address,
                        description: fields.description,
                        lat: fields.lat,
                        lng: fields.lng,
                        model: "User"
                    }
                })
            })).json();
            console.log(response);
        } catch (e) {
            console.log("Error", e)
        }
    }

    const onHandleChange = (newFields) => {
        // console.log(name, value, "SETEANDO", fields);
        setFields({...fields, ...newFields});
    }

    return (
        <>
            <Modal
                isOpen={isOpen}
                onRequestClose={handleClose}
                style={customStyles}
                ariaHideApp={false}
                contentLabel="Addresses"
                overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-50"
            >
                <form
                    onSubmit={handleSubmit}
                    className="w-full flex flex-wrap">
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
                    <ModalSelectMap
                        defaultValues={{
                            address: currentLocation ? currentLocation.address : null,
                            description: currentLocation ? currentLocation.description : null,
                            lat: currentLocation ? currentLocation.lat : null,
                            lng: currentLocation ? currentLocation.lng : null,
                        }}
                        receiveHandleChange={onHandleChange}/>
                    <div className="fixed bottom-0 w-full justify-center flex right-0 bg-white py-4">
                        <button
                            type={"submit"}
                            className="bg-black py-3 px-6 w-6/12 text-white focus:outline-none rounded shadow text-sm">
                            Agregar dirección
                        </button>
                    </div>
                    {/*}*/}
                </form>

            </Modal>
            <div
                title={currentLocation ? currentLocation.address : "Selecciona tu ubicación"}
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
                <h4 className="font-normal ml-8 text-gray-800 truncate ">{currentLocation ? currentLocation.address : "Selecciona tu ubicación"}</h4>
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
const ModalSelectMap = ({receiveHandleChange, defaultValues = {}}) => {
    const [address, setAddress] = useState(defaultValues.address || "");
    const [description, setDescription] = useState(defaultValues.description || "");
    const [currentFeatures, setCurrentFeatures] = useState([]);
    const [loading, setLoading] = useState(false);
    const [currentMap, setCurrentMap] = useState(defaultValues.lat ? [defaultValues.lat, defaultValues.lng] : [-99.7240842389555, 19.6421051526]);
    const [loaded, setLoaded] = useState(false);
    //TODO: Validar los campos de este formulario
    //Apartment: maxLength: 20
    //external_number: maxLength: 10
    //internal_number: maxLength: 10

    useEffect(() => {
        setLoaded(true);
        if (loaded) {
            console.log("HOLA JEJE")
            const NEW_SEARCH = `${currentMap[0]},${currentMap[1]}`
            handleSearch(NEW_SEARCH, 1);
        }
    }, [currentMap])


    const findRegion = (arrayRegion) => {
        let newRegion = arrayRegion.context.find((el) => el.id.includes("region"))
        if (newRegion) {
            return newRegion;
        } else {
            return null;
        }
    }

    const handleSearch = async (e, limit = 5) => {
        setLoading(true);
        console.log(address, description, "AAAIII");
        let newValue = e.target ? e.target.value : e;
        if (e.target) {
            console.log("HAY TARGET");
            setAddress(e.target.value);
        }
        clearTimeout(timer)
        timer = setTimeout(async () => {
            try {
                if (newValue.length > 0) {
                    const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(newValue)}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&bbox=-102.36584333677,18.203715736351,-95.646605055518,20.200815919313&proximity=-99.630833,19.354167`;
                    let response = await (
                        await fetch(URL, {
                            method: "GET"
                        })
                    ).json();
                    if (typeof response === "object") {
                        if (limit > 1) {
                            setCurrentFeatures(response.features || [])
                        } else {
                            if (response.features.length > 0) {
                                let currentFeature = response.features[0];
                                let newRegion = findRegion(currentFeature) // Esto es un array creo
                                console.log(newRegion);
                                if (newRegion !== null) {
                                    if (newRegion.short_code === "MX-MEX" || newRegion.short_code === "MX-DIF") {
                                        // console.log(newRegion.short_code, "Disponible")
                                        // console.log("HOLA", fields);
                                        setAddress(currentFeature.place_name);
                                        receiveHandleChange({
                                            address: currentFeature.place_name,
                                            lat: currentFeature.center[0],
                                            lng: currentFeature.center[1],
                                        });
                                    } else {
                                        console.log("Aún no está disponible aquí")
                                    }
                                }
                            }
                        }
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
        let newRegion = findRegion(e);
        if (newRegion) {
            receiveHandleChange({address: e.place_name, lng: e.center[1], lat: e.center[0]});
            setAddress(e.place_name);
            setCurrentFeatures([]);
            setCurrentMap(e.center);
        } else {
            console.log("Aún no está disponible aquí")
        }

        // Al seleccionar el nuevo address borramos los features
    }

    //Al hacer focus mostramos la dirección si es que se ha cancelado la busqueda anteriormente
    // const onHandleFocus = (e) => {
    //     if (e.target.value.length > 0) {
    //         if (currentFeatures.length <= 0) {
    //             handleSearch(e);
    //         }
    //     }
    // }
    //Recibimos latitude y longitude {lng:Float, lat:Float}
    const handleDrag = (e) => {
        setCurrentMap([e.lng, e.lat]);
    }

    return (
        <>
            <div className="w-full flex flex-wrap px-6 mb-24">
                <div className="relative w-full flex flex-wrap">
                    <Input
                        name={"address"}
                        handleChange={(e) => {
                            handleSearch(e);
                        }}
                        value={address}
                        className="pr-10"
                        // handleFocus={onHandleFocus}
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
                    handleChange={(e) => {
                        setDescription(e.target.value);
                        receiveHandleChange({description: e.target.value});
                    }}
                    value={description}
                    label={"Piso / Oficina / Apto / Depto"}
                    placeholder={"Descripción de la dirección (ej. torre, apartamento)"}/>
                <div className="w-full h-56 bg-gray-200">
                    <MapComponent
                        draggable={true}
                        onDrag={(e) => {
                            handleDrag(e);
                        }}
                        center={currentMap}
                        marker={currentMap}/>
                    {/*Insertar mapa*/}
                </div>
            </div>

        </>
    )
}

const ItemAddress = ({item, handleClick}) => {
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
