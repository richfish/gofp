#THIS FILE CONTAINS MISC SNIPPETS TO ENABLE VARIOUS JS LIBRARIES OR MISC GENERIC BEHAVIOR

$(document).ready ->
  $("[data-custom-alert]").click ->
    message = $(this).data('custom-alert')
    noNavOption = $(this).data('custom-no-nav')
    targetUrl = $(this).attr("href")
    alertBox = $("#global_alert_box")
    alertBox.find('.content p').html(message)
    alertBox.dialog
      dialogClass: 'custom_alert_box'
      modal: true
      buttons:
        "Ok, that sounds good": ->
            alertBox.dialog('close')
            unless noNavOption
              window.location.href = targetUrl
            return
    buttons = $(".ui-dialog-buttonpane button")
    buttons.blur()

  $("[data-custom-confirm]").click ->
    #checkbox shit #if $(this)
    message = $(this).data('custom-confirm')
    noNavOption = $(this).data('custom-no-nav')
    targetUrl = $(this).attr("href")
    form = $(this).parent('form')
    confirmBox = $("#global_confirm_box")
    confirmBox.find('.content p').html(message)
    confirmBox.dialog
      dialogClass: 'custom_confirm_box'
      modal: true
      buttons:
        "No, take me back": =>
          confirmBox.dialog('close')
          return false
        "Yes, I'm Sure": ->
          confirmBox.dialog('close')
          if form.length
            form.submit()
            return true
          unless noNavOption
            window.location.href = targetUrl
          return true
    buttons = $(".ui-dialog-buttonpane button")
    buttons.blur()

  $("textarea").autosize(placeholder: false)

  $("#flash-clear").click ->
    $(this).parent().remove()

  $(".info_panel .clickable span, .info_panel .clickable i").click () ->
    $(".info").toggle()
    $(this).find('i').toggle()

  $("[data-toggle='tooltip']").tooltip()

  $('.datepicker').datepicker
     format: 'dd MM yyyy'
     autoclose: true
     weekStart: true
     startDate: new Date()
     todayHighlight: true
     forceParse: true
     pickerPosition: "bottom-right"
     showMeridian: true

  $('.selectpicker').selectpicker
    size: false

  # $('.submit_button, .submit_button_small, .submit_button_xsmall').click ->
  #   btn = $(this)
  #   btn.prop('disabled', true)
  #   btn.val($('#spinner').show())

  # $('.submit_button_ajax').click ->
  #   btn = $(this)
  #   btn.button('loading')
  #   $(document).ajaxComplete ->
  #     btn.button('reset')

  currencyFormatted = (amount) ->
    i = parseFloat(amount)
    i = 0.00  if isNaN(i)
    minus = ""
    minus = "-"  if i < 0
    i = Math.abs(i)
    i = parseInt((i + .005) * 100)
    i = i / 100
    s = new String(i)
    s += ".00"  if s.indexOf(".") < 0
    s += "0"  if s.indexOf(".") is (s.length - 2)
    s = minus + s

    if parseFloat(s) < 5.00
      s = "5.00"
    return s



  $("#profile_rate_cents").change ->
    val = $(this).val()
    newVal = currencyFormatted(val)
    $(this).val(newVal)



