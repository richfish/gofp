$(document).ready ->
  $(".vertical-app-bar__container").mouseenter ->
    $("body").addClass('disableScroll')
  $(".vertical-app-bar__container").mouseleave ->
    $("body").removeClass('disableScroll')
