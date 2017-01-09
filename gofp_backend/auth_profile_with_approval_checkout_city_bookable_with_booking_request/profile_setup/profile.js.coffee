$(document).ready ->
  $(".multiselect").multiselect
    numberDisplayed: 2

  $(".panel-title").children().click ->
    $(".recent_reviews").remove()
    $(".panel-group").css('margin-top', '0')
    $(".transparency").css('margin-bottom', '-20px')
    $(".panel-heading").remove()

