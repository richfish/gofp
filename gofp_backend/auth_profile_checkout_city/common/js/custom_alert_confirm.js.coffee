window.alert = (message, title ) ->
  alertBox = $("#global_alert_box")
  alertBox.find('.content p').html(message)
  alertBox.dialog
    dialogClass: 'custom_alert_box'
    modal: true
    buttons:
      "Ok, that sounds good": ->
          alertBox.dialog('close')
          return
  buttons = $(".ui-dialog-buttonpane button")
  buttons.blur()
  if buttons.length == 2
    buttons.css('width', '46%')


window.confirm = (message, callback) ->
  #targetUrl = $(this).attr("href");

  confirmBox = $("#global_confirm_box")
  confirmBox.find('.content p').html(message)
  e.preventDefault()
  confirmBox.dialog
    dialogClass: 'custom_alert_box'
    modal: true
    buttons:
      "No, take me back": =>
        confirmBox.dialog('close')
        return false
      "Yes, I'm Sure": ->
        confirmBox.dialog('close')
        if callback && typeof(callback) == 'function'
          callback()
        #window.location.href = targetUrl;
        return true
    close: ->
      $(this).remove()
      return
  buttons = $(".ui-dialog-buttonpane button")
  buttons.blur()
  if buttons.length == 2
    buttons.css('width', '46%')