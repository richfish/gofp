$(document).ready ->

  $("#replace_image").click ->
    $("#asset_image").show()
    $("#replace_image").hide()
    $("#success_saved").hide()

  $("#asset_image").fileupload
    dataType: 'script'
    url: $(this).data('url')

  $("#asset_image").change ->
    $("#upload_error").hide()
    $("#asset_image").hide()
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
