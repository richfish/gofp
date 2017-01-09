$(document).ready ->

  header = $(".splash__header")
  $(window).scroll ->
    offset = header.offset().top
    if offset > 80
      header.css('background-color', 'rgb(1,128,197)')
    else
      header.css('background-color', '#0187d0')


  $(".splash__footer-toggle").click ->
    toggles = $(".splash__footer-toggle")
    slides = $(".splash__slide-img")
    index = $(this).data('toggle-index')
    toggles.removeClass('splash__footer-toggle--active')
    $(this).addClass('splash__footer-toggle--active')
    slides.hide()
    $(".splash__slide-img[data-index=#{index}]").show()
    $(".splash__slide-img[data-index=#{index}]").addClass('animated fadeIn')
