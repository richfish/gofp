# $(document).ready ->
#   hoverEl = $(".mini_hover_overlay")
#   hoverEl.hover(->
#     alert('ok')
#   ), ->
#     alert('nook')

   # $(this).find(".mini_hover_overlay_content").show()
  # hoverEl.click ->
  #   confirm("You will lose any checkout data you've entered")


$(document).ready ->
  $("#profile_hover").contenthover
    overlay_background:'#333'

  $("#cc_number_field").focus ->
    field = $(this)
    field.removeClass('cc_placeholder')
    field.placeholder = 'hi'
  $("#cc_number_field").blur ->
    field = $(this)
    if field.val() == ""
      field.addClass('cc_placeholder') unless field.hasClass('cc_placeholder')

  $('#new_cc').click ->
    returning_cc_box = $(this).closest("#returning-stripe-form")
    returning_cc_box.remove()
    $("#new_cc_form").show()