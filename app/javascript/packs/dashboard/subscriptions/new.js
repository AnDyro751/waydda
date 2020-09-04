console.log("HOLA")
import {loadStripe} from '@stripe/stripe-js';

async function loadNewForm() {
    var element = document.querySelector("#card-element");
    if (element) {
        document.querySelector('#new_subscription').addEventListener('ajax:beforeSend', function (event) {
            event.preventDefault();
        });
        const stripe = await loadStripe('pk_test_2cj88edK605KUkkoRWBH67gq007NzYIttB');
        var elements = stripe.elements();

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
        var form = document.getElementById('new_subscription');
        form.addEventListener('submit', function (event) {
            // return false;
            document.querySelector("#submit-input").disabled = false;
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
    }
}

// Submit the form with the token ID.
function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var form = document.getElementById('new_subscription');
    var old_input = document.querySelector('input[name="card_token"]')
    if (old_input) {
        old_input.value = token.id;
    } else {
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'card_token');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);
    }
    form.submit();

}

loadNewForm()

// Submit the form
// form.submit();
