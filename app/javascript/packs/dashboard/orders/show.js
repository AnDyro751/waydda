import mapboxgl from "mapbox-gl";

if (document.querySelector("#map")) {
    var lat = parseFloat(document.querySelector("#map").dataset["mapLat"]);
    var lng = parseFloat(document.querySelector("#map").dataset["mapLng"]);
    console.log(lat, lng)
    window.current_map = new mapboxgl.Map({
        container: document.querySelector("#map"),
        style: 'mapbox://styles/mapbox/streets-v11', // stylesheet location
        center: [lng ? lng : -99.212594, lat ? lat : 19.455834], // starting position [lng, lat]
        zoom: 16 // starting zoom
    });
}