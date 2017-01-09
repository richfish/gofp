$(document).ready ->
  $(document).on("ajax:success", (e, data) ->
    container = $(".see_more_section")
    successMessage = $("#success_message")
    container.html(successMessage.show())
  ).bind "ajax:error", (e, data) ->
    console.log "validations failed"

  $(".searchnfilter__filter-set-option").click ->
    target = $(this)
    target.toggleClass("searchnfilter__filter-set-option--active")
    activeFilters = $(".searchnfilter__filter-set-option--active")
    filterStr = ""
    for filter in activeFilters
      filter = $(filter)
      filterStr += filter.data('filter') + " "

    $("#filter_search_loading_spinner").show()
    $(".bootcamp_search_result__container").remove()
    $.ajax(
      url: window.location + "&filters=#{filterStr}",
      dataType: 'html'
    ).done (data, status, xhr) ->
      $(".bootcamp_search_results__container").html(data)
      $("#filter_search_loading_spinner").hide()

  $(".program-category__toggle-btn").click (e) ->
    category = $(this).data('program-category-target')
    splash = $("[data-splash-section=#{category}]")
    allSplash = $("[data-splash-section]")
    btn = $(this)
    allBtn = $(".program-category__toggle-btn")
    allBtn.removeClass('active-btn')
    btn.addClass('active-btn')
    allSplash.removeClass('program-category__splash--active')
    splash.addClass('program-category__splash--active')
    $("[data-program-category]").removeClass('program-category--active')
    $("[data-program-category]").hide()
    $("[data-program-category=#{category}]").show()
    setTimeout( ->
      $("[data-program-category=#{category}]").addClass('program-category--active')
    , 100)
  $("[data-program-category='web']").show()
  $("[data-program-category='web']").addClass('program-category--active')

  if gon.guided_search_section
    $("[data-program-category-target='#{gon.guided_search_section}']").click()


  $(".fa.fa-search").click ->
    if $(this).closest(".program-option__tech-list-item").length
      searchText = $(this).closest(".program-option__tech-list-item").find('a').first().text().trim()
    else
      searchText = $(this).closest(".program-option__icon-name-container").find('a').first().text().trim()
    window.location.href = "/search?technology_field=#{searchText}&city=#{'San Francisco Bay Area'}"

  $("#map-view-city-search").change ->
    $(this).closest('form').submit()
