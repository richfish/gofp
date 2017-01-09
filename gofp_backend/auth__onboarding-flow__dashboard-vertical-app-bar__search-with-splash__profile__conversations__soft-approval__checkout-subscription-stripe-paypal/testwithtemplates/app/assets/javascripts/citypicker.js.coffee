$(document).ready ->
  substringMatcher = (strs) ->
    findMatches = (q, cb) ->
      matches = undefined
      substrRegex = undefined

      # an array that will be populated with substring matches
      matches = []

      # regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, "i")

      # iterate through the pool of strings and for any string that
      # contains the substring `q`, add it to the `matches` array
      $.each strs, (i, str) ->

        # the typeahead jQuery plugin expects suggestions to a
        # JavaScript object, refer to typeahead docs for more info
        matches.push value: str  if substrRegex.test(str)
        return

      cb matches
      return

  cities = window.gon.cities

  $(".typeahead").typeahead
    hint: true
    highlight: true
    minLength: 1
  ,
    name: "cities"
    displayKey: "value"
    source: substringMatcher(cities)