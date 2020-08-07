import React, {useState} from "react"
import PropTypes from "prop-types"
import GetImageUrl from "../../lib/getImageUrl";
import MapComponent from "../Place/Map";

export default function DashboardPlacePresentation({place, id}) {
    const [defaultPlace, setDefaultPlace] = useState(place)
    if (!place) {
        return (<h1>Ha ocurrido un error</h1>)
    }

    const searchAddress = async (address, limit = 5) => {
        const link = `https://api.mapbox.com/geocoding/v5/mapbox.places/${address}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&types=country%2Clocality%2Cneighborhood%2Cdistrict%2Cregion%2Cpostcode%2Caddress&limit=${limit}`
        try {
            const results = await (await fetch(link)).json()
            return results.features;
        } catch (e) {
            return []
        }

    }

    const handleDrag = async (e) => {
        console.log(e);
        try {
            let results = await searchAddress(`${e.lng},${e.lat}`, 1);
            if (results.length > 0) {
                setDefaultPlace({...defaultPlace, coordinates: [e.lng, e.lat], address: results[0].place_name})
            }
        } catch (e) {
            console.log("ERR", e)
        }
    }

    return (
        <>
            <h1 className="text-2xl font-bold">{place.name}</h1>
            <h3 className="">{defaultPlace.address}</h3>
            <h5><strong>Coordenadas</strong>: {defaultPlace.coordinates} </h5>
            <img className="h-10 w-10" src={GetImageUrl({publicId: defaultPlace.photo, height: 50, width: 50})}
                 alt="Profile picture"/>
            {place.status !== "pending" &&
            <button id="select-files" data-model="place" data-slug={id} data-attribute="photo">Seleccionar
                archivos</button>
            }
            <div className="h-64 w-full">
                <MapComponent
                    draggable={true}
                    center={[-99.134080, 19.426128]}
                    marker={[-99.134080, 19.426128]}
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
