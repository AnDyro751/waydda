import React, {useState} from 'react'
import MapComponent from "../../Place/Map";

let timeout;

export default function UserEdit({states}) {
    const [address, setAddress] = useState({address: "", location: [-99.134080, 19.426128]})
    const [records, setRecords] = useState([]);
    const [error, setError] = useState(false);

    const searchAddress = async (address, limit = 5) => {
        console.log("BUSCANDP jeje", address)
        const link = `https://api.mapbox.com/geocoding/v5/mapbox.places/${address}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&types=address%2Clocality%2Cpostcode%2Cregion%2Cplace%2Cdistrict%2Cneighborhood&country=mx&limit=${limit}`
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

    return (
        <div className="">
            <form>
                <div className="grid grid cols-12 ">
                    <div className="col-span-12 relative">
                        <input type="text" placeholder="Dirección"
                               onChange={handleSearch}
                        />
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
                        onDrag={handleDrag}
                    />
                </div>
            </form>
        </div>
    )
}