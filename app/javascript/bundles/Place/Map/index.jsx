import React, {useState, useEffect, useRef} from 'react';
import 'mapbox-gl/dist/mapbox-gl.css';
import mapboxgl from 'mapbox-gl'

mapboxgl.accessToken = 'pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ';

export default function MapComponent({center, newCenter, marker, draggable = false, onDrag}) {

    const mapRef = useRef();
    const mapCurrentRef = useRef();
    const currentMarker = useRef();
    const [error, setError] = useState(false);

    useEffect(() => {
        console.log(mapRef.current, mapCurrentRef.current)
        try {
            if (!mapCurrentRef.current) {
                mapCurrentRef.current = new mapboxgl.Map({
                    container: mapRef.current,
                    style: 'mapbox://styles/mapbox/streets-v11',
                    center: center,
                    zoom: 14,
                });
            }

            if (mapCurrentRef.current) {
                mapCurrentRef.current.setCenter(center);
                if (currentMarker.current) {
                    let lngLat = mapCurrentRef.current.getCenter();
                    currentMarker.current.setLngLat(lngLat);
                } else {
                    currentMarker.current = new mapboxgl.Marker()
                        .setLngLat(marker)
                        .addTo(mapCurrentRef.current).setDraggable(draggable);
                    currentMarker.current.on("dragend", (e) => {
                        let lngLat = currentMarker.current.getLngLat();
                        mapCurrentRef.current.setCenter(lngLat);
                        onDrag(lngLat)
                    })
                    mapCurrentRef.current.setCenter(center);
                }
            }
            // console.log("NO HAY")

            setError(false);
        } catch (e) {
            console.log("ERROR MAP", e)
            setError(true);
        }
    }, [center])

    if (error) {
        return (
            <h4 className="font-bold text-xs">Ha ocurrido un error cargando el mapa</h4>
        )
    }
    return (
        <div className="grid grid-cols-12 relative z-0 h-full">
            <div className="col-span-12 h-full m-0 p-0 relative overflow-hidden">
                <div className="h-full bg-gray-400 absolute w-full top-0 left-0 right-0 bottom-0" ref={mapRef}/>
            </div>
        </div>
    )
}

