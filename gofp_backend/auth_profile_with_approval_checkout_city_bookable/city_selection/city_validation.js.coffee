$(document).ready ->

  $("form").submit ->
    $("#rule_match_notice, #no_support_notice").hide()

    cities = window.gon.cities
    cityRules = window.gon.city_rules
    userForm = $(this)
    cityField = userForm.find("#user_city")
    cityInput = cityField.val().toLowerCase()

    cityMatch = false
    ruleMatch = false
    theMatch = null

    for city in cities
      if city.toLowerCase().indexOf(cityInput) != -1
        cityMatch = true
      else if cityInput.indexOf(',') != -1
        index = cityInput.indexOf(',')
        cityInputSimple = cityInput.slice(0, index)
        if city.toLowerCase().indexOf(cityInputSimple) != -1
          ruleMatch = true
          theMatch = city

    unless (cityMatch || ruleMatch)
      for rawCity, goodCity of cityRules
        if rawCity == cityInput
          ruleMatch = true
          theMatch = goodCity
        else if cityInput.indexOf(',') != -1
          index = cityInput.indexOf(',')
          cityInput = cityInput.slice(0, index)
          if rawCity == cityInput
            ruleMatch = true
            theMatch = goodCity

    if ruleMatch
      cityField.val(theMatch)
      $("#rule_match_notice").show()
      return false
    else if !cityMatch
      $("#no_support_notice").show()
      return false

