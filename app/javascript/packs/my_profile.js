import mapboxgl from 'mapbox-gl';

window.mapbox = mapboxgl;

mapboxgl.accessToken = 'pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw';

document.addEventListener("turbolinks:load", () => {
    var lat = document.querySelector("meta[name=user_lat]")
    var lng = document.querySelector("meta[name=user_lng]")
    window.current_map = new mapboxgl.Map({
        container: document.querySelector("#map"),
        style: 'mapbox://styles/mapbox/streets-v11', // stylesheet location
        center: [lat ? lat : -99.212594, lng ? lng : 19.455834], // starting position [lng, lat]
        zoom: 15 // starting zoom
    });
    window.current_marker = new mapboxgl.Marker({draggable: true})
        .setLngLat([lat ? lat : -99.212594, lng ? lng : 19.455834])
        .addTo(window.current_map);
})