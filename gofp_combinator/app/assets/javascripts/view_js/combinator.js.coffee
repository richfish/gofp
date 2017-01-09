$(document).ready ->

  $(".splash__menu-section--backend .splash__menu-section-menu-item").click (e) ->
    e.preventDefault()
    $(".splash__menu-section--backend .splash__menu-section-menu-item--selected").removeClass('splash__menu-section-menu-item--selected')
    selectedVal = $(this).data('backend-type')
    $(this).addClass('splash__menu-section-menu-item--selected')
    $("#combinator_selected_backend").val(selectedVal)
    $("#backend_selection_txt").html("Backend - #{$(this).text()}")

  $(".splash__menu-section--frontend .splash__menu-section-menu-item").click (e) ->
    e.preventDefault()
    #$(".splash__menu-section--frontend .splash__menu-section-menu-item--selected").removeClass('splash__menu-section-menu-item--selected')
    $(this).removeClass('.splash__menu-section-menu-item').addClass('splash__menu-section-menu-item--selected')
    if $(this).data("summary-card-type")
      selectedVal = $(this).data('summary-card-type')
      $("#combinator_selected_summary_card").val(selectedVal)
      $("#summary_card_selection_txt").html("Frontend - Summary Card - #{$(this).text()}")
    else if $(this).data("splash-page-type")
      selectedVal = $(this).data('splash-page-type')
      $("#combinator_selected_splash_page").val(selectedVal)
      $("#splash_page_selection_txt").html("Frontend - Splash Page - #{$(this).text()}")

  $(".splash__menu-section--landing .splash__menu-section-menu-item").click (e) ->
    e.preventDefault()
    $(".splash__menu-section--landing .splash__menu-section-menu-item--selected").removeClass('splash__menu-section-menu-item--selected')
    selectedVal = $(this).data('landing-type')
    $(this).removeClass('.splash__menu-section-menu-item').addClass('splash__menu-section-menu-item--selected')
    $("#combinator_selected_landing").val(selectedVal)
    $("#landing_selection_txt").html("Landing - #{$(this).text()}")

  $(".splash__menu-section--auth .splash__menu-section-menu-item").click (e) ->
    e.preventDefault()
    $(".splash__menu-section--auth .splash__menu-section-menu-item--selected").removeClass('splash__menu-section-menu-item--selected')
    selectedVal = $(this).data('auth-type')
    $(this).removeClass('.splash__menu-section-menu-item').addClass('splash__menu-section-menu-item--selected')
    $("#combinator_selected_auth").val(selectedVal)
    $("#auth_selection_txt").html("Auth - #{$(this).text()}")
