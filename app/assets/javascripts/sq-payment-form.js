/**
 * Define callback function for "sq-button"
 * @param {*} event
 */
function onGetCardNonce(event) {

  // Don't submit the form until SqPaymentForm returns with a nonce
  event.preventDefault();

  // Request a nonce from the SqPaymentForm object
  paymentForm.requestCardNonce();
}

// Initializes the SqPaymentForm object by
// initializing various configuration fields and providing implementation for callback functions.
var paymentForm = new SqPaymentForm({
  // Initialize the payment form elements
  applicationId: applicationId,
  locationId: locationId,
  inputClass: 'sq-input',

  // Customize the CSS for SqPaymentForm iframe elements
  inputStyles: [{
    backgroundColor: 'transparent',
    color: '#333333',
    fontFamily: '"Helvetica Neue", "Helvetica", sans-serif',
    fontSize: '16px',
    fontWeight: '400',
    placeholderColor: '#8594A7',
    placeholderFontWeight: '400',
    padding: '16px',
    _webkitFontSmoothing: 'antialiased',
    _mozOsxFontSmoothing: 'grayscale'
  }],
  // Initialize the credit card placeholders
  cardNumber: {
    elementId: 'sq-card-number',
    placeholder: '•••• •••• •••• ••••'
  },
  cvv: {
    elementId: 'sq-cvv',
    placeholder: 'CVV'
  },
  expirationDate: {
    elementId: 'sq-expiration-date',
    placeholder: 'MM/YY'
  },
  postalCode: {
    elementId: 'sq-postal-code'
  },
  amount: {
    elementId: 'sq-amount'
  },

  // SqPaymentForm callback functions
  callbacks: {
    /*
     * callback function: cardNonceResponseReceived
     * Triggered when: SqPaymentForm completes a card nonce request
     */
    cardNonceResponseReceived: function(errors, nonce, cardData, billingContact, shippingContact) {
      if (errors){
        var error_html = "";
        for (var i =0; i < errors.length; i++){
          error_html += "<li> " + errors[i].message + " </li>";
        }
        document.getElementById("error").innerHTML = error_html;
        document.getElementById('sq-creditcard').disabled = false;

        return;
      }else{
        document.getElementById("error").innerHTML = "";
      }

      // Assign the nonce value to the hidden form field
      document.getElementById('card-nonce').value = nonce;
      // cnon:CBASEHOlP4XcTlGDHLx4dc41wgQ
      // cnon:CBASEHOlP4XcTlGDHLx4dc41wgQ
      // cnon:CBASEHOlP4XcTlGDHLx4dc41wgQ
      // POST the nonce form to the payment processing page
      document.getElementById('nonce-form').submit();

    },

    /*card on file list square pay
     * callback function: unsupportedBrowserDetected
     * Triggered when: the page loads and an unsupported browser is detected
     */
    unsupportedBrowserDetected: function() {
      /* PROVIDE FEEDBACK TO SITE VISITORS */
    },

    /*
     * callback function: inputEventReceived
     * Triggered when: visitors interact with SqPaymentForm iframe elements.
     */
    inputEventReceived: function(inputEvent) {
      switch (inputEvent.eventType) {
        case 'focusClassAdded':
          /* HANDLE AS DESIRED */
          break;
        case 'focusClassRemoved':
          /* HANDLE AS DESIRED */
          break;
        case 'errorClassAdded':
          /* HANDLE AS DESIRED */
          break;
        case 'errorClassRemoved':
          /* HANDLE AS DESIRED */
          break;
        case 'cardBrandChanged':
          /* HANDLE AS DESIRED */
          break;
        case 'postalCodeChanged':
          /* HANDLE AS DESIRED */
          break;
      }
    },
  }
});

function changeAmount() {
  var amount = parseFloat(document.getElementById('amount').value)
  if (isNaN(amount)) {
    amount = 0.00
  }
  document.getElementById('display-amount').innerHTML = '$' + (parseFloat(amount) / 100.0)
}
