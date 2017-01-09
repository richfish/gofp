$(document).ready ->

  $("#payment-form").submit (event) ->
    $(".fa-spin").show()
    $(".submit_button").hide()
    $form = $(this)
    Stripe.card.createToken $form, stripeResponseHandler
    event.preventDefault()

  # $("#accept_btc").click ->
  #   Stripe.bitcoinReceiver.createReceiver({
  #     amount: 2000,
  #     currency: 'usd',
  #     description: 'monkey',
  #     email: 'christian@stripe.com' #email of customer
  #   }, populateBitcoinCheckout)
  #
  # populateBitcoinCheckout = (status, response) ->
  #   if status == 200
  #     strip_btc_address = response.inbound_address
  #     amount = response.bitcoin_amount
  #     uri = response.bitcoin_uri
  #     $("#btc_address").html(strip_btc_address)
  #     $("#btc_amount").html("BTC: #{amount/100000000}")
  #     $("#btc_uri").html(uri)
  #     Stripe.bitcoinReceiver.pollReceiver stripe_btc_address, filledReceiverHandler
  #   else
  #     console.log 'btc error'
  #     #some error stuff
  #
  # filledReceiverHandler = ->
  #   console.log 'now do all the charge stuff'
  #   #submit your form to the server, and create your charge object (or else won't get charged!)

  stripeResponseHandler = (status, response) ->
    $form = $("#payment-form")
    if response.error
      $(".fa-spin").hide()
      $(".submit_button").show()
      $form.find(".payment-errors").text response.error.message
      $.rails.enableFormElements($($.rails.formSubmitSelector)) #annoying issue when using Rail's disable_with
    else
      token = response.id
      $("#stripe_token_internal").append $("<input type='hidden' name='stripeToken' />").val(token)
      $form.get(0).submit()