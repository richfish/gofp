$(document).ready ->
  $("#replace_image").click ->
    $("#profile_avatar").show()
    $("#replace_image").hide()
    $("#success_saved").hide()

  $("#profile_avatar").fileupload
    dataType: 'script'
    url: $(this).data('url')

  $("#profile_avatar").change ->
    $("#upload_error").hide()
    $("#profile_avatar").hide()
    $("#loading_image").show()

  $(document).ajaxComplete (e, data) ->
    if data.statusText == "OK"
      setTimeout(->
        url = decodeURIComponent(data.responseText)
        image = $("form img")
        image.attr('src', url)
        $("#replace_image").show()
        $("#success_saved").show()
        $("#loading_image").hide()
       , 2000)
    else
      $("#loading_image").hide()
      $("#upload_error").show()

  $(".multiselect").multiselect
    numberDisplayed: 2

  $(".panel-title").children().click ->
    $(".recent_reviews").remove()
    $(".panel-group").css('margin-top', '0')
    $(".transparency").css('margin-bottom', '-20px')
    $(".panel-heading").remove()

