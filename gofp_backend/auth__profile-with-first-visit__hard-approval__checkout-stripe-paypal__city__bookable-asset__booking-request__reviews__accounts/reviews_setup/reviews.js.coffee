$(document).ready ->

  $(".stars").click (e) ->
    starRow = $(this)
    star = $(e.target)
    return false if star.data('no-click')
    starGroup = $(this).parent(".star_group")
    ratingNum = star.parent('span').data('rating')
    starRow.hide()
    newStarRow = starGroup.children(".stars#{ratingNum}")
    newStarRow.show()

    hiddenField = starGroup.next()
    hiddenField.val(ratingNum)
