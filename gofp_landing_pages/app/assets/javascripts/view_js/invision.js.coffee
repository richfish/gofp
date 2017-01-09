$(document).ready ->
  $(".splash__testimonials-toggle-img").hover( ->
    $(this).addClass("splash__testimonials-toggle-img--active-preview").removeClass("splash__testimonials-toggle-img")
  , ->
    $(this).removeClass("splash__testimonials-toggle-img--active-preview").addClass("splash__testimonials-toggle-img")
  )

  allTestimonialAvatars = $(".splash__testimonials-toggle-img, .splash__testimonials-toggle-img--active")
  allTestimonialAvatars.click ->
    allTestimonialAvatars.removeClass('splash__testimonials-toggle-img--active').addClass("splash__testimonials-toggle-img")
    $(this).addClass('splash__testimonials-toggle-img--active').removeClass("splash__testimonials-toggle-img")
    index = $(this).data('target')
    newSlide = $(".splash__testimonials-background-image-repo").find("[data-index=#{index}]").clone()
    $(".splash__testimonials").append(newSlide)
    newSlide.addClass('animated slideInUp')
