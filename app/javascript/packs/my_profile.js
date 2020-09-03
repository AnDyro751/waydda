import mapboxgl from 'mapbox-gl';

window.mapbox = mapboxgl;

mapboxgl.accessToken = 'pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw';

var metaElement = document.querySelector("meta[name=action_name]");
if (metaElement) {
    console.log(metaElement.content);
    if (metaElement.content === "my_profile_users" || metaElement.content === "new_places" || metaElement.content === "edit_places" ) {
        var lat = document.querySelector("meta[name=user_lat]")
        var model = document.querySelector("meta[name=model]") ? document.querySelector("meta[name=model]").content : null
        var lng = document.querySelector("meta[name=user_lng]")
        window.current_map = new mapboxgl.Map({
            container: document.querySelector("#map"),
            style: 'mapbox://styles/mapbox/streets-v11', // stylesheet location
            center: [lng ? lng.content : -99.212594, lat ? lat.content : 19.455834], // starting position [lng, lat]
            zoom: 16 // starting zoom
        });
        window.current_marker = new mapboxgl.Marker({draggable: true})
            .setLngLat([lng ? lng.content : -99.212594, lat ? lat.content : 19.455834])
            .addTo(window.current_map);
        window.current_marker.on('dragend', onDragEnd);

        async function onDragEnd() {
            var lngLat = current_marker.getLngLat();
            document.querySelector(`#${model ? model : "address"}_search_address`).value = "";
            document.querySelector(`#${model ? model : "address"}_address`).value = "";
            document.querySelector(`#${model ? model : "address"}_lng`).value = "";
            document.querySelector(`#${model ? model : "address"}_lat`).value = "";
            window.current_map.setCenter([lngLat.lng, lngLat.lat]);
            const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(`${lngLat.lng},${lngLat.lat}`)}.json?access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrN2Y1Nmp4YjB3aG4zZ253YnJoY21kbzkifQ.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&bbox=-102.36584333677,18.203715736351,-95.646605055518,20.200815919313&proximity=-99.630833,19.354167&limit=1`;
            try {
                let response = await (
                    await fetch(URL, {
                        method: "GET"
                    })
                ).json();
                if (Array.isArray(response.features)) {
                    console.log(response.features);
                    if (response.features.length > 0) {
                        var currentFeature = response.features[0];
                        let newRegion = findRegion(currentFeature);
                        if (newRegion !== null) {
                            if (newRegion.short_code === "MX-MEX" || newRegion.short_code === "MX-DIF" || newRegion.short_code === "MX-MEX" || newRegion.short_code === "MX-CMX") {
                                document.querySelector(`#${model ? model : "address"}_lng`).value = currentFeature.center[0];
                                document.querySelector(`#${model ? model : "address"}_lat`).value = currentFeature.center[1];
                                document.querySelector(`#${model ? model : "address"}_search_address`).value = currentFeature.place_name;
                                document.querySelector(`#${model ? model : "address"}_address`).value = currentFeature.place_name;
                            } else {
                                window.addFlashMessage("Región no disponible", true);
                            }
                        } else {
                            window.addFlashMessage("Región no disponible", true);
                        }
                    } else {
                        window.addFlashMessage("Región no disponible", true)
                    }

                }
                // this.addresses = response.features
            } catch (e) {
                window.addFlashMessage("Ha ocurrido un error", true)
            }
        }
    }

}

