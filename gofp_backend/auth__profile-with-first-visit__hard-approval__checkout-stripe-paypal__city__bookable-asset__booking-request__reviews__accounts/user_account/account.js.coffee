$(document).ready ->
  $('#change_password').click ->
    $('#new_password').show()
    $('#new_password :disabled').attr('disabled', false)
    $(".password_control").remove()
    $("#account_email").remove()
    $("#paypal_email").remove()

  $("#change_account_email").click ->
    $("#edit_account_email").show()
    $("#edit_account_email :disabled").attr('disabled', false)
    $("#account_email").remove()
    $("#paypal_email").remove()
    $('#new_password').remove()
    $(".password_control").remove()

  $("#change_paypal_email").click ->
    $("#edit_paypal_email").show()
    $("#edit_paypal_email :disabled").attr('disabled', false)
    $("#paypal_email").remove()
    $("#account_email").remove()
    $('#new_password').remove()
    $(".password_control").remove()





