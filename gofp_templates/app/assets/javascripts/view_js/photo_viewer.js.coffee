$(document).ready ->

  $("#region_hover").contenthover
    overlay_background:'#333'

  $(".dot-control").click ->
    targetIndex = $(this).data("index")
    $(".dot-control").removeClass('active')
    $(this).addClass("active")
    allImages = $(".photo-viewer__photo-container")
    allImages.removeClass("active")
    currentImage = $("[data-image-num='#{targetIndex}']")
    currentImage.addClass("active animated zoomIn")

  $(document).keydown (e) ->
    if $("#photo-viewer:visible").length
      currentDotIndex = $(".dot-control.active").data('index')
      if e.keyCode == 37
        unless currentDotIndex == 1
          $("[data-index=#{currentDotIndex - 1}]").click()
      else if e.keyCode == 39
        unless currentDotIndex == 3
          $("[data-index=#{currentDotIndex + 1}]").click()

  $(".photo-viewer__flag").click ->
    flag = $(this)
    flag.html("<i class='fa fa-spin fa-spinner'></i>")
    $.ajax(
      url: flag.data('url')
    ).done ->
      flag.html("<i style='font-size:12px; font-weight:300; color: grey'>reported</i>")
