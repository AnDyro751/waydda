import {loadStripe} from '@stripe/stripe-js';
import mapboxgl from 'mapbox-gl';

function setMap() {
    mapboxgl.accessToken = 'pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ';
    const map = new mapboxgl.Map({
        container: 'address-map',
        style: 'mapbox://styles/mapbox/streets-v11', // stylesheet location
        center: [document.querySelector("[name='place_lng']").content, document.querySelector("[name='place_lat']").content], // starting position [lng, lat]
        zoom: 14
    });

    var el = document.createElement('div');
    el.className = 'marker rounded-full';
    el.style.backgroundImage =
        `url(https://d1nrrr6y3ujrjz.cloudfront.net/eyJidWNrZXQiOiJ3YXlkZGEtcXIiLCJrZXkiOiJ1dGlscy93LWxvZ28tNS5wbmciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjEwMCwiaGVpZ2h0IjoyMCwiZml0Ijoib3V0c2lkZSJ9fX0=)`;
    el.style.width = '38px';
    el.style.height = '38px';
    el.style.backgroundSize = "cover";
    el.style.backgroundPosition = 'center';
    var elHouse = document.createElement("div");
    elHouse.className = "marker";
    elHouse.style.width = '38px';
    elHouse.style.backgroundSize = "cover";
    elHouse.style.height = '38px';
    elHouse.style.backgroundPosition = 'center';

    elHouse.style.backgroundImage = "url(https://img.icons8.com/cotton/64/000000/dog-house--v1.png)";

    var marker = new mapboxgl.Marker(el)
        .setLngLat([document.querySelector("[name='place_lng']").content, document.querySelector("[name='place_lat']").content])
        .addTo(map);
    new mapboxgl.Marker(elHouse)
        .setLngLat([document.querySelector("[name='address_lng']").content, document.querySelector("[name='address_lat']").content])
        .addTo(map);

}

document.addEventListener("turbolinks:load", async () => {
    setMap()
    const stripe = await loadStripe('pk_test_51H9CZeBOcPJ0nbHcn3sfLIpeMPDr4YfdEWe7ytAM7bge9lzgYQTC1uOAFopBIbeKc7i3btFTEGaHSrnBfTwmmu4o00Dz7IGOu6');
    var elements = stripe.elements();

// Custom styling can be passed to options when creating an Element.
// (Note that this demo uses a wider set of styles than the guide below.)
    var style = {
        base: {
            color: '#32325d',
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': {
                color: '#aab7c4'
            }
        },
        invalid: {
            color: '#fa755a',
            iconColor: '#fa755a'
        }
    };

// Create an instance of the card Element.
    var card = elements.create('card', {style: style});

// Add an instance of the card Element into the `card-element` <div>.
    card.mount('#card-element');

// Handle real-time validation errors from the card Element.
    card.on('change', function (event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

// Handle form submission.
    var form = document.getElementById('payment-form');
    form.addEventListener('submit', function (event) {
        console.log("HOLA");
        event.preventDefault();

        stripe.createToken(card).then(function (result) {
            if (result.error) {
                // Inform the user if there was an error.
                var errorElement = document.getElementById('card-errors');
                errorElement.textContent = result.error.message;
            } else {
                // Send the token to your server.
                stripeTokenHandler(result.token);
                console.log(result);
            }
        });
    });

})

// Submit the form with the token ID.
function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var form = document.getElementById('payment-form');
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token.id);
    form.appendChild(hiddenInput);

    // Submit the form
    // form.submit();
}