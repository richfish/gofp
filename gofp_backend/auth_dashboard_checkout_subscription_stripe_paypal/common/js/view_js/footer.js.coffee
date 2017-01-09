$(document).ready ->

  $(document).on("ajax:success", (e, data) ->
    message = $(".footer__subscription-success-message")
    message.show()
    message.next("form").hide()
  ).bind "ajax:error", (e, data) ->
    console.log "validations failed"
