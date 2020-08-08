import React, {useState} from 'react'
import MapComponent from "../../Place/Map";

let timeout;

export default function UserEdit({states, current_user, current_user_id}) {
    const [address, setAddress] = useState({
        address: "",
        location: [-99.134080, 19.426128],
        default: true,
        external_number: "",
        internal_number: ""
    });
    const [records, setRecords] = useState([]);
    const [error, setError] = useState(false);

    const searchAddress = async (address, limit = 5) => {
        // console.log("BUSCANDP jeje", address)
        const link = `https://api.mapbox.com/geocoding/v5/mapbox.places/${address}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&types=country%2Cregion%2Cdistrict%2Cpostcode%2Clocality%2Cplace%2Cpoi%2Caddress&country=mx&limit=${limit}`
        try {
            const results = await (await fetch(link)).json()
            return results.features;
        } catch (e) {
            return []
        }
    }

    const handleDrag = async (e) => {
        try {
            let results = await searchAddress(`${e.lng},${e.lat}`, 1);
            if (results.length > 0) {
                setAddress({...address, location: [e.lng, e.lat], address: results[0].place_name})
            }
        } catch (e) {
            // setUpdateAddress(false);
            console.log("ERR", e)
        }
    }

    const handleSearch = (e) => {
        clearTimeout(timeout)
        console.log("BUSCANDP", e.target.value)
        let value = e.target.value;
        timeout = setTimeout(async () => {
            try {
                let response = await searchAddress(value);
                setRecords(response || []);
            } catch (e) {
                setRecords([])
            }
        }, 150)
    }

    const handleUpdateAddress = async (e) => {
        e.preventDefault();
        const token =
            document.querySelector('[name=csrf-token]').content

        try {
            let response = await (await fetch(`/addresses`, {
                method: "post",
                body: JSON.stringify({
                    address: {
                        // TODO: Al actualizar el address este se debe traer de la lat y lng, no del texto
                        location: {
                            lat: address.location[1],
                            lng: address.location[0]
                        },
                        model: "User",
                        model_id: current_user_id,
                        default: address.default,
                        external_number: address.external_number,
                        internal_number: address.internal_number
                    }
                }),
                headers: {
                    'X-CSRF-TOKEN': token,
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            })).json();
            console.log("R", response);
        } catch (e) {
            console.log("E", e)
        }
    }

    return (
        <div className="">
            <form onSubmit={handleUpdateAddress}>
                <div className="grid grid cols-12 ">
                    <div className="col-span-12 relative">
                        <input
                            value={address.address}
                            type="text" placeholder="Dirección"
                            onChange={(e) => {
                                setAddress({...address, address: e.target.value});
                                handleSearch(e);
                            }}
                        />
                        {/*TODO: Add state*/}
                        <div className="grid grid-cols-12">
                            <div className="col-span-12">
                                <div className="grid grid-cols-12">
                                    <div className="col-span-3">
                                        Numero exterior
                                    </div>
                                    <div className="col-span-9">
                                        {/*EXTERNAL NUMBER*/}
                                        <input
                                            value={address.external_number}
                                            onChange={(e) => {
                                                setAddress({...address, external_number: e.target.value});
                                            }}
                                            placeholder={"#12"}
                                            type="text" className="border"/>
                                    </div>
                                </div>
                                <div className="grid grid-cols-12">
                                    <div className="col-span-3">
                                        Numero interior
                                    </div>
                                    <div className="col-span-9">
                                        {/*INTERNAL NUMBER*/}
                                        <input
                                            value={address.internal_number}
                                            onChange={(e) => {
                                                setAddress({...address, internal_number: e.target.value});
                                            }}
                                            placeholder={"#41 B"}
                                            type="text" className="border"/>
                                    </div>
                                </div>
                            </div>
                            <div className="col-span-3">
                                <input
                                    onChange={(e) => {
                                        setAddress({...address, default: e.target.checked})
                                    }}
                                    type="radio" value={address.default}/>
                            </div>
                            <div className="col-span-9">Agregar cómo dirección principal</div>
                        </div>
                        <button
                            type={"submit"}
                            // onClick={handleUpdateAddress}
                            disabled={!address.address}
                            className="text-white bg-black px-6 py-3 rounded shadow-2xl">
                            Actualizar ubicación
                        </button>
                        {
                            records.length > 0 &&
                            <div
                                className="absolute z-50 bottom-0 transform translate-y-full left-0 right-0 p-3 bg-blue-100">
                                {records.map((record, i) => (
                                    <div key={i}
                                         onClick={() => {
                                             setAddress({address: record.place_name, location: record.center})
                                             setRecords([]);
                                         }}
                                         className="cursor-pointer">{record.place_name}</div>
                                ))}
                            </div>
                        }
                    </div>
                </div>
                <p><strong>Dirección</strong>: {address.address}</p>
                <div className="h-64 w-full">
                    <MapComponent
                        draggable={true}
                        center={address.location}
                        marker={address.location}
                        // newCenter={address.address}
                        onDrag={handleDrag}
                    />
                </div>
            </form>
        </div>
    )
}