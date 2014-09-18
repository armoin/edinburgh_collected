$(document).ready ->
  $('body').on 'click', '.flashes .close', (e) ->
    $(this).parent().hide()

