$(document).ready ->
  authInput = $(".auth__signup-form-field input")

  authInput.focus ->
    $(this).parent(".auth__signup-form-field").find('.fa').css('color', '#18bdcb')
  authInput.blur ->
    $(this).parent(".auth__signup-form-field").find('.fa').css('color', '#e6e1d7')
