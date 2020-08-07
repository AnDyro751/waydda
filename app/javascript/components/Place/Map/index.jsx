import React, {useState, useEffect, useRef} from 'react';
import mapboxgl from 'mapbox-gl'
import ReactMapGL from 'react-map-gl';

mapboxgl.accessToken = 'pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ';

export default function MapComponent({center, marker}) {

    const mapRef = useRef();
    const [error, setError] = useState(false);
    const [viewport, setViewport] = useState({
        width: 400,
        height: 400,
        latitude: 37.7577,
        longitude: -122.4376,
        zoom: 8
    })
    useEffect(() => {
        console.log("HOLA")
        try {
            let map = new mapboxgl.Map({
                container: mapRef.current,
                style: 'mapbox://styles/mapbox/streets-v11',
                center: center,
                zoom: 14,
            });
            new mapboxgl.Marker()
                .setLngLat(marker)
                .addTo(map);
            setError(false);
        } catch (e) {
            console.log("ERROR MAP", e)
            setError(true);
        }
    }, [])

    if (error) {
        return (
            <h4 className="font-bold text-xs">Ha ocurrido un error cargando el mapa</h4>
        )
    }
    return (
        <div className="grid grid-cols-12 my-6 relative z-0">
            <div className="col-span-12 h-56 md:h-xxl m-0 p-0 relative overflow-hidden">
                {/*<ReactMapGL*/}
                {/*    {...viewport}*/}
                {/*    onViewportChange={(nviewport) => setViewport(nviewport)}*/}
                {/*/>*/}
                <div className="h-full bg-gray-400 absolute w-full top-0 left-0 right-0 bottom-0" ref={mapRef}/>
            </div>
        </div>
    )
}

