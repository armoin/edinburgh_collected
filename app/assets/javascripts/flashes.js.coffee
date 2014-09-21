flashCloser = ->
  $('body').on 'click', '.flashes .close', (e) ->
    $(this).parent().hide()

# on a page refresh ...
$(document).ready flashCloser

# on a turbolinks load ...
$(document).on 'page:load', flashCloser
