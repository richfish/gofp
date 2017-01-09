$(document).ready ->
  fadeableLinks = $(".splash__header-link-list-item-fade-left")
  searchField = $(".splash__header-link-list-item-search-field")
  $(".splash__header-link-list-item-search-toggle").click ->
    if searchField.is(":visible")
      fadeableLinks.removeClass('fadeOutLeft').addClass('fadeInLeft')
      searchField.removeClass('fadeInRight').addClass('fadeOutRight')
      setTimeout( ->
        searchField.hide()
      , 1000)
    else
      fadeableLinks.addClass('animated fadeOutLeft')
      searchField.show()
      searchField.addClass('animated fadeInRight')
