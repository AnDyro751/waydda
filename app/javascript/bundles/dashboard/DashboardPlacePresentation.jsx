import React, {useState} from "react"
import PropTypes from "prop-types"
import GetImageUrl from "../../lib/getImageUrl";
import MapComponent from "../Place/Map";

export default function DashboardPlacePresentation({place, id}) {
    const [defaultPlace, setDefaultPlace] = useState(place)
    const [updateAddress, setUpdateAddress] = useState(false);
    if (!place) {
        return (<h1>Ha ocurrido un error</h1>)
    }

    const searchAddress = async (address, limit = 5) => {
        const link = `https://api.mapbox.com/geocoding/v5/mapbox.places/${address}.json?access_token=pk.eyJ1Ijoid2F5ZGRhIiwiYSI6ImNrZzYwZWJiYzB6bjMycW5udmd1NHNscDAifQ.wkmzM9Mh8XyPXZ8BgpyJXg&cachebuster=1596775236930&autocomplete=true&country=mx&types=country%2Clocality%2Cneighborhood%2Cdistrict%2Cregion%2Cpostcode%2Caddress&limit=${limit}`
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
                setDefaultPlace({...defaultPlace, location: [e.lng, e.lat], address: results[0].place_name})
                setUpdateAddress(true);
            }
        } catch (e) {
            setUpdateAddress(false);
            console.log("ERR", e)
        }
    }


    const handleUpdateAddress = async () => {
        try {
            const token =
                document.querySelector('[name=csrf-token]').content

            // axios.defaults.headers.common['X-CSRF-TOKEN'] = token
            let response = await (await fetch(`/dashboard/places/${place.slug}`, {
                method: "put",
                body: JSON.stringify({
                    place: {
                        location: {
                            lat: defaultPlace.location[1],
                            lng: defaultPlace.location[0]
                        }
                    }
                }),
                headers: {
                    'X-CSRF-TOKEN': token,
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            })).json();
            console.log(response)
            return response;
        } catch (e) {
            console.log(e, "ERROR")
            // setError(true);
        }
    }

    return (
        <>
            <h1 className="text-2xl font-bold">{place.name}</h1>
            <h3 className="">{defaultPlace.address}</h3>
            <h5><strong>Coordenadas</strong>: {defaultPlace.location} </h5>
            <img className="h-10 w-10" src={GetImageUrl({publicId: defaultPlace.photo, height: 50, width: 50})}
                 alt="Profile picture"/>
            {place.status !== "pending" &&
            <button id="select-files" data-model="place" data-slug={id} data-attribute="photo">Seleccionar
                archivos</button>
            }
            {
                updateAddress &&
                <button
                    onClick={handleUpdateAddress}
                    className="bg-black shadow-2xl px-6 py-3 rounded"
                    disabled={!updateAddress}>
                    Actualizar dirección
                </button>
            }
            <div className="h-64 w-full">
                <MapComponent
                    draggable={true}
                    center={defaultPlace.location ? defaultPlace.location : [-99.134080, 19.426128]}
                    marker={defaultPlace.location ? defaultPlace.location : [-99.134080, 19.426128]}
                    onDrag={handleDrag}
                />
            </div>
        </>
    )
}
DashboardPlacePresentation.propTypes = {
    id: PropTypes.string.isRequired,
    place: PropTypes.object.isRequired
}
