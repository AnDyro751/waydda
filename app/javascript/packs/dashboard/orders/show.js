import mapboxgl from "mapbox-gl";

mapboxgl.accessToken = 'pk.eyJ1Ijoid2F5ZGRhIiwiYSI6ImNrZzYwZWJiYzB6bjMycW5udmd1NHNscDAifQ.wkmzM9Mh8XyPXZ8BgpyJXg';
if (document.querySelector("#map")) {
    let lat = parseFloat(document.querySelector("#map").dataset["mapLat"]);
    let lng = parseFloat(document.querySelector("#map").dataset["mapLng"]);
    let lngPlace = parseFloat(document.querySelector("#map").dataset["placeLng"]);
    let latPlace = parseFloat(document.querySelector("#map").dataset["placeLat"]);
    console.log(lat, lng)
    window.current_map = new mapboxgl.Map({
        container: document.querySelector("#map"),
        style: 'mapbox://styles/mapbox/streets-v11', // stylesheet location
        center: [lng ? lng : -99.212594, lat ? lat : 19.455834], // starting position [lng, lat]
        zoom: 16 // starting zoom
    });
    let currentMarker = new mapboxgl.Marker()
        .setLngLat([lng, lat])
        .addTo(window.current_map).setDraggable(false);
    let placeMarker = new mapboxgl.Marker()
        .setLngLat([lngPlace, latPlace])
        .addTo(window.current_map).setDraggable(false);
}
